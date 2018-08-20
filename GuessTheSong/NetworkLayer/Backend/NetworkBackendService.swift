//
//  NetworkBackendService.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 18/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class NetworkBackendService: BackendService {
    
    private let conf: BackendConfiguration
    private let service = NetworkService()
    
    public init(_ conf: BackendConfiguration) {
        self.conf = conf
    }
    
    public func request(_ request: BackendAPIRequest, success: ((Data) -> ())?, failure: ((NSError) -> ())?) {
        let url = conf.baseURL.appendingPathComponent(request.path)
        let headers = request.headers
        
        service.makeRequest(for: url, method: request.method, query: request.task, params: request.parameters, headers: headers, success: { (data) in
            if let data = data {
                success?(data)
            }
        }) { (data, error, statusCode) in
            if data == nil {
                failure?(error ?? NSError(domain: "Error on backend side", code: 0, userInfo: nil))
            }
        }
    }
    
    public func cancel() {
        self.service.cancel()
    }
    
    
}
