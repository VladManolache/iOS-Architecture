//
//  DemoNetworkTask.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 12/09/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit
import SwiftyJSON


class DemoNetworkTask: BaseNetworkTask<DemoResponse>, DatabaseServiceInjected {
    
    override init() {
        super.init()
        
        request = DemoRequest(value: 0)
    }
    
    override func handleSuccess(response: AnyObject?) {
        
        if response != nil {
            let model = DemoResponse(response: response!)
            
            // Validate response.
            if !model.isValid() {
                self.handleFailure(error: NetworkError.invalidResponseData as NSError)
                return
            }
            
            let entity = DemoEntity(value: model.value)
            databaseService.demoDataSource.insert(item: entity)
            
            self.success?(model)
        }
    }
    
}
