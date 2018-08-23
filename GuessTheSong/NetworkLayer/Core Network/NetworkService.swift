//
//  HTTPMethod.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 26/06/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation


/// REST Methods
///
/// - get: GET
/// - post: POST
/// - put: PUT
/// - delete: DELETE
public enum HTTPMethod: String {
    case get, post, put, delete
}

/// The differents types of query
///
/// - json: Add the parameters in a Json inside the HTTP body request
/// - path: Add the parameters as query in the URL
/// - music: Add the parameters and music bytes in a Json inside the HTTP body request
public enum HTTPQuery {
    case json, path, music
}

public typealias Parameters = [String: Any]

public class NetworkService {
    
    private var task: URLSessionDataTask?
    private var successCodes: CountableRange<Int> = 200..<299
    private var failureCodes: CountableRange<Int> = 400..<599
    
    func makeRequest(for url: URL,
                     method: HTTPMethod,
                     query type: HTTPQuery,
                     params: [String: String]?,
                     headers: [String: String]? = nil,
                     success: ((Data?) -> Void)? = nil,
                     failure: ((_ data: Data?, _ error: NSError?, _ responseCode: Int) -> Void)? = nil) {
    
        var mutableRequest = NetworkQueryGenerator().makeQuery(for: url, params: params, type: type)
        mutableRequest.httpMethod = method.rawValue
        mutableRequest.allHTTPHeaderFields = headers
        
        print("The url of request is: \(mutableRequest.url)")
        
        let session = URLSession.shared
        task = session.dataTask(with: mutableRequest, completionHandler: { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                failure?(data, error as NSError?, 0)
                return
            }
            
            if let error = error {
                failure?(data, error as NSError, httpResponse.statusCode)
                return
            }
            if self.successCodes.contains(httpResponse.statusCode){
                print("request's been finished with success \(String(describing: mutableRequest.url?.absoluteString))")
                success?(data)
            } else if self.failureCodes.contains(httpResponse.statusCode){
                print("request's been finished with failure \(httpResponse.statusCode)")
                failure?(data,error as NSError?, httpResponse.statusCode)
            } else {
                print("Request finished with failure on the server.")
                failure?(data, error as NSError?, httpResponse.statusCode)
            }
        })
        
        task?.resume()
        
        
    }
    
    func cancel() {
        task?.cancel()
    }
}
