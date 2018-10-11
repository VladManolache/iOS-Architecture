//
//  AnalyticsService.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 04/08/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Firebase


// MARK: - Dependency Injection

struct AnalyticsServiceInjectionMap {
    
    static var analyticsService = AnalyticsService()

}

protocol AnalyticsServiceInjected { }

extension AnalyticsServiceInjected {
    
    var analyticsService: AnalyticsService { return AnalyticsServiceInjectionMap.analyticsService }

}


/**
 * Facilitates analytics logging.
 */
struct AnalyticsService {
    
    private let serialQueue = DispatchQueue(label: "com.endava.architectureproposal-V1.analytics")
    
    
    /**
     * Log a new event.
     */
    func logEvent(eventType: AnalyticsEventSubtypeProtocol) {
        
        serialQueue.async {
            
            Analytics.logEvent(eventType.parent.description, parameters: eventType.properties)
            
        }
    }
}
