//
//  FinishGameRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 04/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct FinishGameRequest: BackendAPIRequest {
    
    private let id: String
    private let token: String
    private let time: String
    
    init(token: String, id: Int, time: Int) {
        self.id = String(describing: id)
        self.token = token
        self.time = String(describing: time)
    }
    
    var path: String {
        return "/games/\(id)/finish_game/"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: HTTPQuery {
        return .json
    }
    
    var parameters: [String : String]? {
        return [
            "status": "success",
            "time": time
        ]
    }
    
    var headers: [String : String]? {
        var jsonHeaders = defaultJSONHeader()
        jsonHeaders["Authorization"] = "JWT \(token)"
        return jsonHeaders
    }
}
