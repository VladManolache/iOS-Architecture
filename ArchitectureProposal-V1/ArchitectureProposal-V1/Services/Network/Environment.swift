//
//  Environment.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 13/03/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation


/**
 * Environment is a struct which encapsulate all the informations we need to perform the setup of a NetworkDispatcher.
 */
struct Environment {
    
    // List of possible network configurations. 
    struct List {
        static var mockEnvironment = Environment(name: "localhost", endpoint: "http://localhost:8085")
        static var productionEnvironment = Environment(name: "localhost", endpoint: "http://localhost:8085")
    }
    

    // Name of the environment.
    public var name: String
    
    // Base URL of the environment.
    public var endpoint: String
    
    /* 
     * This is the list of common headers which will be part of each Request.
     * Some headers value maybe overwritten by Request's own headers.
     */
    public var headers: [String: Any] = [:]
    
    // Cache policy.
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    
    /* 
     * Initialize a new Environment.
     *
     * - Parameters:
     *   - name: name of the environment
     *   - endpoint: base url
     */
    public init(name: String, endpoint: String) {
        self.name = name
        self.endpoint = endpoint
    }
}
