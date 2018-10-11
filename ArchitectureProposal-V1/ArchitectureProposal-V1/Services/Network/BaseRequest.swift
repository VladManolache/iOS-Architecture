//
//  BaseRequest.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 13/03/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Alamofire


enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

/**
 * Protocol to be implemented by all request objects.
 */
protocol BaseRequestProtocol {

    func path() -> String
    
    func method() -> HTTPMethod
    
    func bodyParams() -> [String: Any]?
    
    func headers() -> [String: String]?
    
}

/**
 * Base class for all request objects.
 */
class BaseRequest: URLRequestConvertible, BaseRequestProtocol {
    
    /**
     * The base url for this request.
     */
    var endpoint: String!
    
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            return (path(), bodyParams()!)
        }()
        
        let url = try endpoint.asURL()
        
        // Build the url request.
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = method().rawValue
        urlRequest.allHTTPHeaderFields = headers()

        return try JSONEncoding.default.encode(urlRequest, with: result.parameters)
    }
    
    
    // MARK: - BaseRequestProtocol
    
    /**
     * Request relative path. 
     *
     * Must be overriden in subclass.
     */
    func path() -> String {
        preconditionFailure("This method must be overridden in subclass.")
    }
    
    /**
     * Request type. Possible values: GET, POST, PUT, PATCH, DELETE.
     *
     * Default value is GET.
     */
    func method() -> HTTPMethod {
        return .GET
    }
    
    /**
     * Request body. 
     * 
     * The default value is [:].
     */
    func bodyParams() -> [String: Any]? {
        return [:]
    }
    
    /**
     * Request headers. 
     *
     * The default value is ["Content-Type": "application/json"].
     */
    func headers() -> [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
}
