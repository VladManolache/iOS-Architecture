//
//  DatabaseService.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 24/03/2017.
//  Copyright © 2017 Endava. All rights reserved.
//


// MARK: - Dependency Injection

private struct DatabaseServiceInjectionMap {
    static var databaseService = DatabaseService()
}

protocol DatabaseServiceInjected { }

extension DatabaseServiceInjected {
    var databaseService: DatabaseService { return DatabaseServiceInjectionMap.databaseService }
}


/**
 * Facilities all interactions with the database.
 */
struct DatabaseService {
 
    var demoDataSource: DemoDataSource

        
    init() {
        demoDataSource = DemoDataSource()
    }
    
    /**
     * Clear all data sources.
     */
    func clear() {
        demoDataSource.clean()
    }
}
