//
//  DemoEntity.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 12/09/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation


class DemoEntity: BaseDBEntity {
    
    struct Constants {
        static let value = "value"
    }
    
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
    
}
