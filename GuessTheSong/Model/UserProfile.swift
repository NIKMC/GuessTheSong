//
//  UserProfile.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 06/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class Player {
    private var id: Int
    private var name: String
    private var rating = 0
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func updateRating(newValue: Int) {
        self.rating += newValue
    }
    
    func getRating() -> Int {
        return self.rating
    }
}
