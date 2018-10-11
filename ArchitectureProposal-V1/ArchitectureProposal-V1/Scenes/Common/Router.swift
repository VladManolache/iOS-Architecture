//
//  Router.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 22/12/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit


/**
 * Protocol to be implemented by all router objects.
 */
protocol Router {
    
    /**
     * Alias for the list of valid routes from the current scene.
     */
    associatedtype RouteType
    
    /**
     * Executes transitions based on the provided route type.
     *
     * - Parameter route: Transition to execute
     * - Parameter parameters: Transition parameters
     */
    func route(to route: RouteType, parameters: Any?)
    
}

