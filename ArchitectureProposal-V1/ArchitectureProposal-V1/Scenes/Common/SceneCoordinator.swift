//
//  SceneCoordinator.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 12/09/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


// MARK: - Dependency Injection

struct SceneCoordinatorInjectionMap {
    static var sceneCoordinator = SceneCoordinator(window: UIApplication.shared.windows.first!)
}

protocol SceneCoordinatorInjected { }

extension SceneCoordinatorInjected {
    var sceneCoordinator: SceneCoordinator { return SceneCoordinatorInjectionMap.sceneCoordinator }
}


// MARK: - SceneCoordinator

final class SceneCoordinator: SceneCoordinatorType {
    
    private var window: UIWindow
    
    required init(window: UIWindow) {
        self.window = window
    }

    
    // MARK: - Transitions
    
    @discardableResult
    func transition(to viewController: UIViewController, type: SceneTransitionType) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        let currentViewController = retrieveCurrentViewController()

        switch type {
        case .root:
            window.rootViewController = viewController
            subject.onCompleted()
            
        case .push:
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: true)
            
        case .modal:
            currentViewController.present(viewController, animated: true) {
                subject.onCompleted()
            }
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    @discardableResult
    func pop(animated: Bool) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        let currentViewController = retrieveCurrentViewController()

        if currentViewController.presentingViewController != nil {
            // dismiss a modal controller
            currentViewController.dismiss(animated: animated) {
                subject.onCompleted()
            }
        } else if let navigationController = currentViewController.navigationController {
            // navigate up the stack
            // one-off subscription to be notified when pop complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(currentViewController)")
            }
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
        return subject.asObservable().take(1).ignoreElements()
    }
    
    
    // MARK: - Utils
    
    /**
     * Retrieve the first item if we are inside a navigation controller, otherwise return the rootViewController.
     */
    private func retrieveCurrentViewController() -> UIViewController {
        let viewController = window.rootViewController!
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return viewController
        }
    }
    
}


// MARK: - Identifiers

extension SceneCoordinator {
    
    /**
     * List of all storyboard identifiers.
     */
    enum StoryboardIdentifiers: String {
        case mainStoryboard = "Main"
    }
    
    /**
     * List of all view controller identifiers.
     */
    enum VCIdentifiers: String {
        case mainViewController = "MainViewController"
        case secondViewController = "SecondViewController"
    }
    
    /**
     * List of all segue identifiers.
     */
    enum SegueIdentifiers: String {
        case segue
    }
    
}
