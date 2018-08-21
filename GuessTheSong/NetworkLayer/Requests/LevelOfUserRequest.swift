//
//  LevelOfUserRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct LevelOfUserRequest: BackendAPIRequest {
    
    private let id: String
    
    init(id: String) {
        self.id = id
    }
    
    var path: String {
        return "/users/level"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: HTTPQuery {
        return .json
    }
    
    var parameters: [String : String]? {
        return [
            "id": id
        ]
    }
    
    var headers: [String : String]? {
        return defaultJSONHeader()
    }
}
