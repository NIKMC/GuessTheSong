//
//  ProfileRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct ProfileRequest: BackendAPIRequest {
    
    private let token: String
//    private let id: String
    
    init(token: String) {
            self.token = token
//            self.id = userId
        }
    
    var path: String {
        return "/users/profile/"
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
//            "token": token,
//            "id": id
//        ]
    }
    
    var headers: [String : String]? {
        var jsonHeaders = defaultJSONHeader()
        jsonHeaders["Authorization"] = "JWT \(token)"
        return jsonHeaders
    }
}
