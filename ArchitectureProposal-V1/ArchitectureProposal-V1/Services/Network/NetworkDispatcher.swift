//
//  NetworkEngine.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 13/03/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Alamofire
import Swifter


// MARK: - Dependency Injection

struct NetworkInjectionMap {
    
#if DEBUG
    static var networkDispatcher = NetworkDispatcher(environment: Environment.List.productionEnvironment)
#else
    static var networkDispatcher = NetworkDispatcher(environment: Environment.List.mockEnvironment)
#endif
    
    static var httpServer = getHttpServer()
    static func getHttpServer() -> HttpServer {
        let server = HttpServer()
        try? server.start(8085)
        
        // Important - For all requests, set the default response the httpServer should return.
        updateHttpServer(server, request: DemoRequest(value: 0))
        
        return server
    }
    
    /**
     * Set the default response the httpServer should return for the provided request.
     */
    static func updateHttpServer(_ httpServer: HttpServer, request: BaseRequest) {
        httpServer.POST[request.path()] = { request in
            var resourceFileName = NSURL(string: request.path)?.lastPathComponent
            resourceFileName = resourceFileName?.capitalized.appending("Response")
            
            let path = Bundle.main.path(forResource: resourceFileName!, ofType: "json")
            let data = try? Foundation.Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
            let text = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            return HttpResponse.ok(.text( text! as String ) )
        }
    }
}

protocol NetworkDispatcherInjected { }

extension NetworkDispatcherInjected {
    
    var networkDispatcher: NetworkDispatcher { return NetworkInjectionMap.networkDispatcher }
    var httpServer: HttpServer { return NetworkInjectionMap.httpServer }
    
}


// MARK: - DispatcherProtocol

protocol DispatcherProtocol {
    
    // Configure the dispatcher with an environment
    init(environment: Environment)
    
    func execute(request: BaseRequest,
                 successHandler: ((AnyObject?) -> Void)?,
                 failureHandler: ((NSError) -> Void)? )
    
}


// MARK: - NetworkDispatcher

/**
 * The dispatcher is responsible for executing a Request by calling the underlyning 
 *  networking layer (maybe URLSession, Alamofire or just a fake dispatcher which return mocked results).
 */
struct NetworkDispatcher: DispatcherProtocol, KeychainServiceInjected {
    
    /**
     * Configuration for this dispatcher.
     */
    var environment: Environment
    
    /**
     * SessionManager which adds security exceptions for http requests.
     */
    private var manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "localhost": .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()


    init(environment: Environment) {
        self.environment = environment
        
        // Initialize the httpServer.
        _ = NetworkInjectionMap.httpServer
        
        manager.adapter = AuthHandler(sessionManager: manager, baseURLString: environment.endpoint)
        manager.retrier = AuthHandler(sessionManager: manager, baseURLString: environment.endpoint)
    }
    
    /**
     * Execute the request and return the result of the request.
     *
     * - Parameter request: Request object 
     * - Parameter successHandler: Closure to call in case of success
     * - Parameter failureHandler: Closure to call in case of failure
     */
    func execute(request: BaseRequest,
                 successHandler: ((AnyObject?) -> Void)? = nil,
                 failureHandler: ((NSError) -> Void)? = nil ) {
        
        do {
            // Set the base url for the request to be executed. The request is not linked to a dispatcher before this.
            request.endpoint = environment.endpoint
            
            var urlRequest = try request.asURLRequest()
            urlRequest.cachePolicy = environment.cachePolicy
            
            print("Will execute request: \(urlRequest)")
            manager.request( urlRequest )
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                        
                    case .success:
                        if let response: AnyObject = response.result.value as AnyObject? {
                            print("The json response is: \(response)")
                            
                            successHandler?(response)
                        }
                        else {
                            print("No json response received.")
                        }
                        
                    case .failure(let error):
                        print("Error while fetching data: \(error)")
                        
                        // Retrieve server response as a dictionary.
                        var dictionary: [AnyHashable: Any]?
                        if let responseData = response.data {
                            do {
                                dictionary = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [AnyHashable : Any]
                            }
                            catch {
                                print("Failed to decode response data")
                            }
                        }
                        
                        // Need to convert error response to NSError.
                        var myError: NSError
                        if let err = error as? AFError {
                            
                            // AFError - May contain a nil response code in some cases.
                            if err.responseCode != nil {
                                myError = NSError(domain: NSCocoaErrorDomain, code: err.responseCode!, userInfo: dictionary)
                            }
                            else {
                                myError = NSError(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: dictionary)
                            }
                        }
                        else if let err = error as? URLError {
                            // URLError - always has a status code.
                            myError = NSError(domain: NSURLErrorDomain, code: err.code.rawValue, userInfo: dictionary)
                        }
                        else {
                            // Unknown error - cast unknown error to NSError.
                            myError = NSError(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: dictionary)
                        }
                        
                        failureHandler?(myError)
                    }
                }
        }
        catch let error {
            // Handle exception thrown during execution of a request.
            print("Error while executing request: \(error)")
        }
        
    }
    
}
