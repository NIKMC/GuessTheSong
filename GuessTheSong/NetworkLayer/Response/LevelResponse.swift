//
//  LevelResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 15/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class LevelResponse: Codable {
    var url: String
    var songs: [SongResponse]
    var name: String
    var experience: Int
    var created_at: String
    
    init(url: String, name: String, experience: Int, created_at: String, songs: [SongResponse]) {
        self.url = url
        self.name = name
        self.experience = experience
        self.songs = songs
        self.created_at = created_at
    }
    
    func getLevelURL() -> String {
        return url
    }
    
}
