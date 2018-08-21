//
//  GameResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class GameResponse: Codable {
    var id: Int
    var status: String
    var level: Int
    var created_at: String
    var user: Int
    
    init(id: Int, status: String, levelURL level: Int, created_at: String, user: Int ) {
        self.id = id
        self.status = status
        self.level = level
        self.user = user
        self.created_at = created_at
    }
    
    func getGameURL() -> Int {
        return id
    }
    
    func getLevelURL() -> Int {
        return level
    }
    
}
