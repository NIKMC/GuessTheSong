//
//  ProfileResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 15/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class ProfileResponse: Codable {
    var id: Int
    var username: String
    var first_name: String
    var last_name: String
    var email: String
    var single_player_experience: String
    var multi_player_experience: String
    
    init(id: Int, username: String,first_name: String,last_name: String,email: String,single_player_experience: String, multi_player_experience: String) {
        self.id = id
        self.username = username
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.single_player_experience = single_player_experience
        self.multi_player_experience = multi_player_experience
    }
}
