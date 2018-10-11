//
//  StatefulDataSource.swift
//  DataSourceProposal
//
//  Created by User on 14/12/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation


protocol DataSourceProtocol: class {
    
    associatedtype Item
    
    var onItemsUpdated: (([Item]) -> Void)? { get set }
        
    func loadContent()
    
    func clearContent()
    
}


class StatefulDataSource<T>: NSObject, DataSourceProtocol {
    
    typealias Item = T
    
    var items = [T]()
    
    var onItemsUpdated: (([T]) -> Void)?
    
    private let stateMachine = StateMachine()
    
    
    // MARK: - Content

    func loadContent() {
        beginLoading()
        executeLoadContent( { items in
            self.endLoading()

            self.onItemsUpdated?(self.items)
        })
    }
    
    func executeLoadContent(_ handler: @escaping ([Item]) -> ()) {
        fatalError("Must override in subclass")
    }
    
    func clearContent() {
        items.removeAll()
        transition(toState: .noContent)
        onItemsUpdated?(items)
    }
    
    
    // MARK: - Transitions
    
    func beginLoading() {
        if stateMachine.getCurrentState() == StateMachine.State.initial {
            transition(toState: StateMachine.State.loadingContent)
        }
        else {
            transition(toState: StateMachine.State.refreshingContent)
        }
    }
    
    func endLoading(error: Error? = nil) {
        if error != nil {
            transition(toState: StateMachine.State.error)
        }
        
        if items.count == 0 {
            transition(toState: StateMachine.State.noContent)
        }
        else {
            transition(toState: StateMachine.State.contentLoaded)
        }
    }
    
    func transition(toState state: StateMachine.State) {
        try! stateMachine.transition(toState: state)
    }
    
    
    // MARK: - Utils

    func getCurrentState() -> StateMachine.State {
        return stateMachine.getCurrentState()
    }
}
