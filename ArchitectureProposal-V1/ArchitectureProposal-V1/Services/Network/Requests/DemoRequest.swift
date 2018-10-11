//
//  DemoRequest.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 12/09/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation
import UIKit


class DemoRequest: BaseRequest {
    
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    override func path() -> String {
        return "/demo/"
    }
    
    override func method() -> HTTPMethod {
        return .POST
    }
    
    override func headers() -> [String : String]? {
        return [:]
    }
    
    override func bodyParams() -> [String : Any]? {
        return [:]
    }
}
