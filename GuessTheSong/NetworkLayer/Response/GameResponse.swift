//
//  GameResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class GameResponse: Codable {
    var url: String
    var status: String
    var level: String
    var created_at: String
    var user: ProfileResponse
    
    init(gameURL url: String, status: String, levelURL level: String, created_at: String, user: ProfileResponse ) {
        self.url = url
        self.status = status
        self.level = level
        self.user = user
        self.created_at = created_at
    }
    
    func getGameURL() -> String {
        return url
    }
    
    func getLevelURL() -> String {
        return level
    }
    
}
