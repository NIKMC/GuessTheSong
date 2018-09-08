//
//  FinishGameResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 04/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class FinishGameResponse: Codable {
    
    var id: Int
    var status: StatusLevel.RawValue
    var created_at: String
    var user: Int
    var level: Int
    var single_player_experience: String
    
    
    init(id: Int, status: String, created_at: String, user: Int, level: Int, single_player_experience: String) {
        self.id = id
        self.status = status
        self.created_at = created_at
        self.user = user
        self.level = level
        self.single_player_experience = single_player_experience
    }

}
