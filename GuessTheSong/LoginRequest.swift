//
//  LoginRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 04/04/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import SocketIO

struct LoginRequest: SocketData {
    let username: String
    let password: String
    
    func socketRepresentation() -> SocketData {
        return ["username": username, "password": password]
    }
}
