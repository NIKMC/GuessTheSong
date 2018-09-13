//
//  MultiPlayerResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 13/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class MultiPlayerResponse: Codable {
    
    var websocket_url: String
    var game: MultiPlayerGameResponse
    
    init(websocket_url: String, game: MultiPlayerGameResponse) {
        self.websocket_url = websocket_url
        self.game = game
    }

}

public class MultiPlayerGameResponse: Codable {
    var id: Int
    var status: String
    var created_at: String
    var number_of_players: Int
    var score_multiplier: Double
    var creator: Int
    var users: [ProfileResponse]
    var songs: [SongResponse]
    var ready_players: [ProfileResponse]
    var success_players: [ProfileResponse]
    
    init(id: Int, status: String, created_at: String, number_of_players: Int, score_multiplier: Double, creator: Int, users: [ProfileResponse], songs: [SongResponse], ready_players: [ProfileResponse], success_players: [ProfileResponse]) {
        self.id = id
        self.status = status
        self.created_at = created_at
        self.number_of_players = number_of_players
        self.score_multiplier = score_multiplier
        self.creator = creator
        self.users = users
        self.songs = songs
        self.ready_players = ready_players
        self .success_players = success_players
    }
}

