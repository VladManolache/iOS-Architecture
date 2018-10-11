//
//  BaseNetworkTask.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 13/03/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation


enum NetworkError: CustomNSError {
    case invalidResponseData
    case badRequest
    case forbidden
    case unauthorized
    case cvrNotFound
    
    static var errorDomain: String {
        return "NetworkError"
    }
    
    var errorCode: Int {
        switch self {
        case .invalidResponseData:
            return 0
        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .cvrNotFound:
            return 404
        }
    }
    
    var errorUserInfo: [String: Any] {
        return [:]
    }
    
    static func networkError(from error : Error) -> NetworkError? {
        
        if let code = error._userInfo!["code"] as? String {
            switch code {
            case "BAD_REQUEST":
                return .badRequest
            case  "FORBIDDEN":
                return .forbidden
            default:
                return nil
            }
        }
        
        return nil
    }
}


protocol BaseNetworkTaskProtocol {
    func execute()
}

/**
 * Protocol to be implemented by all network tasks.
 *
 * - note:
 * T represents the output in case of success.
 */
class BaseNetworkTask<T>: Operation, BaseNetworkTaskProtocol, NetworkDispatcherInjected {
    
    // Request to execute.
    var request: BaseRequest!
    
    // Success and failure handlers.
    var success: ((T) -> Void)?
    var failure: ((NSError) -> Void)?
    
    
    /**
     * Execute the current task. A default implementation is provided that uses the injected
     *  network dispatcher instance to execute the request.
     */
    func execute() {
        self.networkDispatcher.execute(request: self.request, successHandler:self.handleSuccess, failureHandler: self.handleFailure)
    }
    
    /**
     * Handles request success.
     *
     * - note:
     * If a success handler is set, this method must be overwritten in the subclasses.
     *  Otherwise, this method will throw an exception.
     */
    func handleSuccess(response: AnyObject?) {
        preconditionFailure("Must be overwritten by the subclass")
    }
    
    /**
     * Handles request failure.
     */
    func handleFailure(error: NSError) {
        self.failure?(error)
    }
    
}
