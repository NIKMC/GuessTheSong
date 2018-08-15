

//
//  ResponseMessage.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 30/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

struct ResponseMessage: Codable {
    var err: Bool
    var msg: String?
    var token: String?
}

struct ResponseCreateGameMessage: Codable {
    var msg : String
    var room : String
//    var err : Bool
}

struct ResponseStartGameMessage: Codable {
    var action : String
//    var err : Bool
}

struct ResponseReadyGameMessage: Codable {
    var msg : String
    var err : Bool
}

struct ResponseDownloadSongs: Codable {
    var msg : String
    var err : Bool
}
