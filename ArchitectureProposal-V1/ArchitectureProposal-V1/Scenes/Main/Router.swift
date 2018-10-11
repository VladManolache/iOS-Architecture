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
     * Transition type.
     */
    associatedtype RouteType
    
    /**
     * Routes based on a provided routeType.
     *
     * - Parameter route: Transition to execute
     * - Parameter context: Previous viewController
     * - Parameter parameters: Transition parameters
     */
    func route(to route: RouteType,
               from context: UIViewController,
               parameters: Any?)
    
}

