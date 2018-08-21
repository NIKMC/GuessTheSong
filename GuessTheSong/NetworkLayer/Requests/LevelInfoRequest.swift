//
//  LevelInfoRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 07/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct LevelInfoRequest: BackendAPIRequest {
    
    private let id: String
    
    init(id: Int) {
        self.id = String(describing: id)
    }
    
    var path: String {
        return "/levels/"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: HTTPQuery {
        return .path
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
