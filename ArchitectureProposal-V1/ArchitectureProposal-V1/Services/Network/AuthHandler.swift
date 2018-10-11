//
//  AuthHandler.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 14/07/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Alamofire


class AuthHandler: RequestAdapter, RequestRetrier, KeychainServiceInjected, AnalyticsServiceInjected {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void
    
    private let sessionManager: SessionManager
    
    private let lock = NSLock()
    
    private var baseURLString: String
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    
    // MARK: - Initialization
    
    public init(sessionManager: SessionManager, baseURLString: String) {
        self.sessionManager = sessionManager
        self.baseURLString = baseURLString
    }
    
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
            var urlRequest = urlRequest
            
            if let jwtToken = keychainService.getToken() {
                urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            }
            
            return urlRequest
        }
        
        return urlRequest
    }
    
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == NetworkError.unauthorized.errorCode {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        let token = keychainService.getToken()
        guard !isRefreshing && token != nil else { return }
        
        isRefreshing = true
        
        // TODO - Refresh token. isRefreshing should be set to false when done.
        
        isRefreshing = false
        
    }
}
