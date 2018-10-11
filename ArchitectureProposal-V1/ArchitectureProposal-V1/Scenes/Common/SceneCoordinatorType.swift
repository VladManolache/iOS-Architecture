//
//  SceneCoordinatorType.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 12/09/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit
import RxSwift


protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    // transition to another scene
    @discardableResult
    func transition(to viewController: UIViewController, type: SceneTransitionType) -> Observable<Void>
    
    // pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Observable<Void>
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Observable<Void> {
        return pop(animated: true)
    }
}
