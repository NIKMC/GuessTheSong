//
//  GamesListResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class GamesResponse: Codable {
    
    var count: Int
    var next: Int?
    var previous: Int?
    var results: [GameResponse]
    
    init(count: Int, results: [GameResponse]) {
        self.count = count
        self.results = results
    }
}
