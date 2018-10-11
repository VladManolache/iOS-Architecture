//
//  KeychainService.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 12/05/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation
import Valet
import RxSwift


// MARK: - Dependency Injection

struct KeychainServiceInjectionMap {
    static var keychainService = KeychainService()
}

protocol KeychainServiceInjected { }

extension KeychainServiceInjected {
    
    var keychainService: KeychainService { return KeychainServiceInjectionMap.keychainService }
    
}

/**
 * Facilitates all interactions with the keychain.
 */
struct KeychainService {
 
    /**
     * Wrapper that enables easy interaction with the keychain.
     */
    private var valet = VALValet(identifier: "ArchitectureProposal-V1", accessibility: .alwaysThisDeviceOnly)!

    /**
     * Keys of objects stored in the Keychain.
     */
    struct Constants {
        // Add keys here.
        static var token = "kToken"
    }
    
    
    // MARK: - Token
    
    let tokenObservable = PublishSubject<String?>()
    
    func getToken() -> String? {
        return valet.string(forKey: Constants.token)
    }
    
    func setToken(token: String) {
        valet.setString(token, forKey: Constants.token)
        tokenObservable.onNext(token)
    }
    
    func clearToken() {
        valet.removeObject(forKey: Constants.token)
        tokenObservable.onNext(nil)
    }
    
    
    // MARK: - Generic
    
    func getObject(key: String) -> Foundation.Data? {
        return valet.object(forKey: key)
    }
    
    func getString(key: String) -> String? {
        return valet.string(forKey: key)
    }

    func setObject(object: Foundation.Data, key: String) {
        valet.setObject(object, forKey: key)
    }
    
    func setString(string: String, key: String) {
        valet.setString(string, forKey: key)
    }
    
    func clear() {
        valet.removeAllObjects()
    }
    
}
