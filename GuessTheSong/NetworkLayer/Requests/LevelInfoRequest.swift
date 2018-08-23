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
    private let token: String
    
    init(token: String, id: Int) {
        self.id = String(describing: id)
        self.token = token
    }
    
    var path: String {
        return "/levels/\(id)/"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: HTTPQuery {
        return .path
    }
    
    var parameters: [String : String]? {
        return nil
    }
    
    var headers: [String : String]? {
        var jsonHeaders = defaultJSONHeader()
        jsonHeaders["Authorization"] = "JWT \(token)"
        return jsonHeaders
    }
}
