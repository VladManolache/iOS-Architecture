//
//  DemoDataSource.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 12/09/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import RealmSwift


class DemoDataSource: BaseRealmDataSource<DemoEntity, DemoDBModel> {
    
    override func getModelArray(results: Results<Object>) -> [Model] {
        return results.map({ ($0 as? DBModel)!.entity })
    }
    
    override func createDBModel(model: Model) -> Object {
        return DBModel(model)
    }
}
