//
//  MainRouter.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 22/12/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit


final class MainRouter: Router, SceneCoordinatorInjected {
    typealias RouteType = Route
    
    enum Route: String {
        case second
    }
    
    func route(to route: RouteType, parameters: Any? = nil) {
        
        switch route {
        case .second:
            
            let storyboard = UIStoryboard(name: SceneCoordinator.StoryboardIdentifiers.mainStoryboard.rawValue, bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: SceneCoordinator.VCIdentifiers.secondViewController.rawValue)
            let observable = sceneCoordinator.transition(to: newVC, type: .push)
            _ = observable.do(onCompleted: {
                // Finished navigating to the new VC.
            })
        }
    }
    
}
