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
    private let passwordRep: String
    
    init(email: String, login: String, password: String, passwordRep: String) {
        self.email = email
        self.login = login
        self.password = password
        self.passwordRep = passwordRep
    }
    
    var path: String {
        return "/users/sign_up"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: HTTPQuery {
        return .json
    }
    
    var parameters: [String : String]? {
        return [
            "email": email,
            "login": login,
            "password": password,
            "passwordRep": passwordRep
        ]
    }
    
    var headers: [String : String]? {
        return defaultJSONHeader()
    }
}
