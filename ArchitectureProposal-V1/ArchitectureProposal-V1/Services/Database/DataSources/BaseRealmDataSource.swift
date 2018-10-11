//
//  BaseRealmDataSource.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 27/04/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift


// MARK: - Dependency Injection

struct RealmDatabaseInjectionMap {
    static var databaseQueue = DispatchQueue(label: "databaseQueue", attributes: .concurrent)
    static let realmConfig = getInMemoryRealmConfig()
    
    static func getInMemoryRealmConfig() -> Realm.Configuration {
        var config = Realm.Configuration()
        config.inMemoryIdentifier = "ArchitectureProposal-V1InMemory" // this Realm is memory only.
        return config
    }
    
    static func getRealm() -> Realm! {
        return try? Realm(configuration: RealmDatabaseInjectionMap.realmConfig)
    }
}

protocol RealmDatabaseInjected { }

extension RealmDatabaseInjected {
    var realm: Realm { return RealmDatabaseInjectionMap.getRealm() }
    var databaseQueue: DispatchQueue { return RealmDatabaseInjectionMap.databaseQueue }
}


/**
 * Base class for all objects that will interact directly with a Realm instance.
 *
 * - note: This class requires two generic parameters:
 * 1) Model object that should be made available outside of the database layer.
 * 2) Realm object to be used only inside the database layer.
 */ 
class BaseRealmDataSource<T, U>: DataSourceProtocol, RealmDatabaseInjected {
    
    typealias Model = T
    typealias DBModel = U
    
    /**
     * Can be used to listen for changes to the current database table.
     *
     * - note: When a database change happens, database objects are mapped to regular objects.
     */
    var observable: Observable<[Model]>!

    
    // MARK: - Initialisation
    
    init() {
        
        observable = Observable.collection(from: realm.objects( (DBModel.self as? Object.Type)! ))
            .map { results -> [Model] in
                return self.getModelArray(results: results)
            }
        
    }
    
    
    // MARK: - Internal
    
    /**
     * Used to convert the Realm results to [Model]. 
     *
     * - note: This must be overwritten by all subclasses.
     */
    internal func getModelArray(results: Results<Object>) -> [T] {
        fatalError("Must override in subclass")
    }
    
    /**
     * Used to create a new DBModel using a Model object.
     *
     * - note: This must be overwritten by all subclasses.
     */
    internal func createDBModel(model: T) -> Object {
        fatalError("Must override in subclass")
    }
    
    
    // MARK: - Observable
    
    /**
     * Returns an observable that listens for changes on a specific table.
     *
     * - note: When a database change happens, database objects are mapped to regular objects.
     *
     * - Parameter predicate: Condition to apply to the querry.
     */
    func getObservable(predicate: NSPredicate) -> Observable<[Model]> {
        return Observable.collection(from: realm.objects( (DBModel.self as? Object.Type)! ).filter(predicate))
            .map { results -> [Model] in
                return self.getModelArray(results: results)
        }
    }
    
    /**
     * Returns an observable that listens for changes on a specific table. The results are sorted.
     *
     * - note: When a database change happens, database objects are mapped to regular objects.
     *
     * - Parameter predicate: Condition to apply to the querry.
     * - Parameter sortKey: Sort the data by the provided column.
     */
    func getObservable(predicate: NSPredicate, sortKey: String) -> Observable<[Model]> {
        let objects = realm.objects( (DBModel.self as? Object.Type)! ).filter(predicate)
        return Observable.collection(from: objects.sorted(byKeyPath: sortKey, ascending: true))
            .map { results -> [Model] in
                return self.getModelArray(results: results)
        }
    }
    
    
    // MARK: - CRUD operations
    
    /**
     * Insert a single entry into the table.
     */
    func insert(item: T) {
        
        databaseQueue.async {
            let realm: Realm = self.realm
            try? realm.write {
                realm.add(self.createDBModel(model: item))
            }
        }
    }
    
    /**
     * Insert a list of items into the table. Optionally, clear before inserting.
     */
    func insertAll(items: [T], clear: Bool) {
        
        databaseQueue.async {
            let realm: Realm = self.realm
            try? realm.write {
                var list = [Object]()
                for i in 0..<items.count {
                    list.append(self.createDBModel(model: items[i]) )
                }
                
                if clear {
                    realm.delete(realm.objects( (U.self as? Object.Type)! ))
                }
                
                realm.add(list)
            }
        }
    }
    
    /**
     * Retrieve all entries from the current table.
     */
    func getAll() -> [T] {
        return getModelArray(results: realm.objects( (U.self as? Object.Type)! ))
    }
    
    /**
     * Retrieve all entries that match the provided criteria.
     */
    func getByColumn(name: String, value: String) -> [T] {
        return getModelArray(results: realm.objects( (U.self as? Object.Type)! ).filter(NSPredicate(format: "\(name) == %@", value)))
    }
    
    /** 
     * Update an entry from the table. Insert it the entry does not exist.
     */
    func update(item: T) {
        
        databaseQueue.async {
            let realm: Realm = self.realm
            try? realm.write {
                realm.add(self.createDBModel(model: item), update: true)
            }
        }
    }
    
    /**
     * Delete an entry from the table.
     */
    func delete(item: T) {
        
        databaseQueue.async {
            let realm: Realm = self.realm
            try? realm.write {
                realm.delete(self.createDBModel(model: item))
            }
        }
    }
    
    /**
     * Clear the current table.
     */
    func clean() {
        
        databaseQueue.async {
            let realm: Realm = self.realm
            try? realm.write {
                realm.delete(realm.objects( (U.self as? Object.Type)! ))
            }
        }
    }
}
