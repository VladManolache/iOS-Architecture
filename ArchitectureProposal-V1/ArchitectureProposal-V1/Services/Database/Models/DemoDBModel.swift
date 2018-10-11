//
//  DemoDBModel.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 12/09/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


class DemoDBModel: Object {
    
    dynamic var value: Int = 0
    
    convenience init(_ demoEntity: DemoEntity) {
        self.init()
        
        value = Int(demoEntity.value)
    }
    
    var entity: DemoEntity {
        return DemoEntity(
            value: Int(value)
        )
    }
}
