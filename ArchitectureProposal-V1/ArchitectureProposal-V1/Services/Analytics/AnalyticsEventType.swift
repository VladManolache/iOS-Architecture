//
//  AnalyticsEvent.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 04/08/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation


/**
 * Protocol to be implemented by all types of analytics events.
 */
protocol AnalyticsEventSubtypeProtocol {
    
    /**
     * The name of the event subtype.
     */
    var name: String { get }
    
    /**
     * Parent of the event subtype.
     */
    var parent: AnalyticsEventType { get }
    
    /**
     * Dictionary of properties associated with the event subtype.
     */
    var properties: [String: Any]? { get }
    
}


// MARK: - List of event types.

/**
 * List of all event types. 
 *
 * - note: Each high-level event type has a correspondent that encapsulates all the sub-events.
 */
enum AnalyticsEventType {

    /**
     * Events related to the state of the app.
     */
    case appStateEvent(subtype: AnalyticsEventSubtypeProtocol)
    
    /**
     * Retrieve description as a string with the following format: [Event_SubEvent].
     */
    var description: String {
        switch self {
        case .appStateEvent(let subtype):
            return "AppStateEvent_" + subtype.name
        }
    }
}


// MARK: - AppState events

extension AnalyticsEventType {
    
    /**
     * Events related to the state of the app.
     */
    enum AppStateEvent: String, AnalyticsEventSubtypeProtocol {
        case started
        case didBecomeActive
        case didEnterBackground
        case terminated
                
        var name: String {
            return self.rawValue
        }
        
        var parent: AnalyticsEventType {
            return .appStateEvent(subtype: self)
        }

        var properties: [String : Any]? {
            return [:]
        }
    }
}
