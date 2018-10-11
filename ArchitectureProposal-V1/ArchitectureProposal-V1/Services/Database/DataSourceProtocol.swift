//
//  DataSourceProtocol.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 27/04/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation


/**
 * Protocol that should be implemented by all classes that will interact directly with a data source.
 *
 * - Important: Objects implementing this protocol reside at the service database layer.
 */
protocol DataSourceProtocol {
    
    /**
     * Model object to be exposed to the rest of the app.
     */
    associatedtype Model
    
    /**
     * Model object to be used which is specific for the used database implementation.
     *
     * - note: This should not be exposed outside of the database layer.
     */
    associatedtype DBModel
    
    
    /**
     * Get all entries from the current table.
     *
     * - returns: Array of model objects.
     */
    func getAll() -> [Model]
    
    /**
     * Get all entries that match the provided name and value filter.
     *
     * - returns: Array of model objects.
     */
    func getByColumn(name: String, value: String) -> [Model]
    
    /**
     * Insert an item into the current table.
     */
    func insert(item: Model)
    
    /**
     * Insert a list of items into the current table.
     *
     * The clear flag indicates if the table should be purged before the insert is made.
     */
    func insertAll(items: [Model], clear: Bool)
    
    /**
     * Update a specific item from the table. If the item does not exist, it will be inserted.
     */
    func update(item: Model)
    
    /**
     * Delete an item from the current table.
     */
    func delete(item: Model)
    
    /**
     * Purge the current table.
     */
    func clean()
    
}
