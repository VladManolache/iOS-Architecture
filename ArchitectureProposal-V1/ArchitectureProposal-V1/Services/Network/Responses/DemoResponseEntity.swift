//
//  DemoResponseEntity.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 12/09/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import SwiftyJSON


class DemoResponse: BaseResponseEntity {
    
    let value: Int
    
    init(response: AnyObject) {
        let json = JSON(response)
        
        value = json["value"].intValue
    }
    
    func isValid() -> Bool {
        return true
    }
    
}
