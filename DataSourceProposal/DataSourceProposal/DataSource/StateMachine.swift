//
//  StateMachine.swift
//  DataSourceProposal
//
//  Created by Vlad Manolache on 13/12/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation

/**
 * Responsible for maintaining the current state and executing valid state transitions.
 */
class StateMachine: NSObject {
    
    
    // MARK: - Enums
    
    /**
     * List of possible state transition errors.
     */
    enum StateTransitionError: Error {
        case invalidTransition(initialState: State, destinationState: State)
    }

    /**
     * List of possible states and valid transitions from each state.
     *
     * - note: State priority may matter when dealing with an aggregate of states.
     */
    enum State: Int {
        case loadingContent
        case refreshingContent
        case error
        case noContent
        case contentLoaded
        case initial
        
        static var allValues: [State] = [.loadingContent, .refreshingContent, .error, .noContent, .contentLoaded, .initial]
        
        var validTransitions: [State] {
            switch self {
            case .loadingContent:
                return [.contentLoaded, .noContent, .error]
            case .refreshingContent:
                return [.contentLoaded, .noContent, .error]
            case .error:
                return [.loadingContent, .refreshingContent, .noContent, .contentLoaded]
            case .noContent:
                return [.refreshingContent, .contentLoaded, .error]
            case .contentLoaded:
                return [.refreshingContent, .noContent, .error]
            case .initial:
                return [.loadingContent]
            }
        }
    }
    
    private var currentState = State.initial
    
    
    // MARK: - State transition
    
    /**
     * Executes a valid state transition or throws an exception.
     *
     * - parameter state: Desired destination state
     *
     * - throws: StateTransitionError when an invalid state transition is attempted
     */
    func transition(toState state: State) throws {
        guard currentState != state else {
            return
        }
        
        guard validateTransition(toState: state) else {
            throw StateTransitionError.invalidTransition(initialState: currentState, destinationState: state)
        }
        
        currentState = state
    }
    
    /**
     * Checks if a state transition from the current to the desired state would be valid.
     *
     * - parameter state: Desipred destination state
     */
    func validateTransition(toState state: State) -> Bool {
        return currentState.validTransitions.contains(state)
    }
    
    
    // MARK: - Utils
    
    func getCurrentState() -> State {
        return currentState
    }

}
