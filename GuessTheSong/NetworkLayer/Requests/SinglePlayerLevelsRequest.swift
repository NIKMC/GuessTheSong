//
//  SinglePlayerLevelsRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct SinglePlayerLevelsRequest: BackendAPIRequest {
    
//    private let login: String
//    private let password: String
    
//    init(login: String, password: String) {
//        self.login = login
//        self.password = password
//    }
//
    var path: String {
        return "/users/sign_in"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: HTTPQuery {
        return .path
    }
    
    var parameters: [String : String]? {
        return nil
//        return [
//            "login": login,
//            "password": password
//        ]
    }
    
    var headers: [String : String]? {
        return defaultJSONHeader()
    }
}
