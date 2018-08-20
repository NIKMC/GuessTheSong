//
//  SongsListResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 15/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class SongsListResponse: Codable {
    
    var count: Int
    var next: Int?
    var previous: Int?
    var results: [SongResponse]
    
    init(count: Int, results: [SongResponse]) {
        self.count = count
        self.results = results
    }
    
    func getListOfSongs() -> [SongResponse] {
        return results
    }
    
}
