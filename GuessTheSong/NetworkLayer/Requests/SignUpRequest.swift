//
//  SignUprequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct SignUpRequest: BackendAPIRequest {
    
    private let email: String
    private let login: String
    private let password: String
    private let first_name: String
    private let last_name: String
    
    init(email: String, login: String, password: String, first_name: String, last_name: String) {
        self.email = email
        self.login = login
        self.password = password
        self.first_name = first_name
        self.last_name = last_name
    }
    
    var path: String {
        return "/users/"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: HTTPQuery {
        return .json
    }
    
    var parameters: [String : String]? {
        return [
            "username": login,
            "first_name": first_name,
            "last_name": last_name,
            "email": email,
            "password": password
        ]
    }
    
    var headers: [String : String]? {
        return defaultJSONHeader()
    }
}
