//
//  ListOfLevelsRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 16/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct ListOfLevelsRequest: BackendAPIRequest {
    
    private let token: String
    
    init(token: String) {
        self.token = token
    }
    
    var path: String {
        return "/games/my_games/"
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
