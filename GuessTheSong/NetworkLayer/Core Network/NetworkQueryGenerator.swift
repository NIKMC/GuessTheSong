//
//  NetworkQueryGeneration.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 18/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct NetworkQueryGenerator {
    func makeQuery(for url: URL, params: [String: String]?, type: HTTPQuery) -> URLRequest {
        switch type {
        case .json:
//            print("json")
            var mutableRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            if let params = params {
                mutableRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            }
            return mutableRequest
        
        case .path:
            let urlComponent = NSURLComponents(string: url.absoluteString)!
            guard let params = params else { return URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)}
            
            urlComponent.queryItems = params.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            return URLRequest(url: urlComponent.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        case .multi:
            let urlComponent = NSURLComponents(string: url.absoluteString)!
            guard let params = params else { return URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90.0)}
            
            urlComponent.queryItems = params.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            return URLRequest(url: urlComponent.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90.0)
        }
    }
}
