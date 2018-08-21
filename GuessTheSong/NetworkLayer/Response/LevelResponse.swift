//
//  LevelResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 15/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class LevelResponse: Codable {
    var id: Int
    var songs: [SongResponse]
    var name: String
    var experience: Int
    var created_at: String
    
    init(id: Int, name: String, experience: Int, created_at: String, songs: [SongResponse]) {
        self.id = id
        self.name = name
        self.experience = experience
        self.songs = songs
        self.created_at = created_at
    }
    
    func getLevelURL() -> Int {
        return id
    }
    
}
