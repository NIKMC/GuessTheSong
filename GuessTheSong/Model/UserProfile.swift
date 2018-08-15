//
//  UserProfile.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 06/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class UserProfile: Codable {
    var rating: Double
    
    
    init(rating: Double) {
        self.rating = rating
        
    }
}
