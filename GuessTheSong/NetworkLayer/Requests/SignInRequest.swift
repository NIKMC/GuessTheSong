//
//  SignInRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 18/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct SignInRequest: BackendAPIRequest {
    
    private let username: String
    private let password: String
    
    init(login: String, password: String) {
        self.username = login
        self.password = password
    }
    
    var path: String {
        return "/api-token-auth/"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: HTTPQuery {
        return .json
    }
    
    var parameters: [String : String]? {
        return [
            "username": username,
            "password": password
        ]
    }
    
    var headers: [String : String]? {
        return defaultJSONHeader()
    }
}
