//
//  DownloadMusicRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 07/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct DownloadMusicRequest: BackendAPIRequest {
    
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    var path: String {
        return "/music/"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: HTTPQuery {
        return .multi
    }
    
    var parameters: [String : String]? {
        return [
            "url": url
        ]
    }
    
    var headers: [String : String]? {
        return defaultJSONHeader()
    }
}
