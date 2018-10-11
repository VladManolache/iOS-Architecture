//
//  UserDefaultsService.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 24/05/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


// MARK: - Dependency Injection

private struct UserDefaultsServiceInjectionMap {
    static var userDefaultsService = UserDefaultsService()
}

protocol UserDefaultsServiceInjected { }

extension UserDefaultsServiceInjected {
    
    var userDefaultsService: UserDefaultsService { return UserDefaultsServiceInjectionMap.userDefaultsService }
    
}


/**
 * Facilitates all interactions with userDefaults.
 *
 * - note: There is a bug in iOS causing the two events to be fired instead of just one:
 * https://github.com/ReactiveX/RxSwift/issues/1143
 */
struct UserDefaultsService {
    
    /**
     * Keys of objects stored in the UserDefaults.
     */
    struct Constants {
        // Add keys here.
    }
    
    
    // MARK: - Generic
    
    func getObject(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    func setObject(object: Foundation.Data, key: String) {
        UserDefaults.standard.set(key, forKey: key)
    }
    
    /**
     * Remove all user defaults for the app.
     */
    func clear() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
}
