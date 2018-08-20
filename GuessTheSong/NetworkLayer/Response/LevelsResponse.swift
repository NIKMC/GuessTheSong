//
//  LevelsResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 15/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class LevelsResponse: Codable {
 
    var count: Int
    var next: Int?
    var previous: Int?
    var results: [LevelResponse]

    init(count: Int, results: [LevelResponse]) {
        self.count = count
        self.results = results
    }
}
