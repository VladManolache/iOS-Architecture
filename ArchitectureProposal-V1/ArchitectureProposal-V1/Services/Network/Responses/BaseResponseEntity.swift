//
//  BaseResponseEntity.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 11/04/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation


/**
 * Protocol to be implemented by all response objects.
 *
 * - Important: Objects implementing this protocol reside at the service network layer.
 */
protocol BaseResponseEntity {
    
    func isValid() -> Bool
    
}
