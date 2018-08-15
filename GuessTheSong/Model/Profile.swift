//
//  UserProfile.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 08/04/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class Profile: Codable {
    var email: String=""
    var password: String=""
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
