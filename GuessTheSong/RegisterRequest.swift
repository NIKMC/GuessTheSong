//
//  RegisterRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 04/04/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import SocketIO

struct RegisterRequest: SocketData {
    let username: String
    let email: String
    let password: String
    let password2: String
    
    func socketRepresentation() -> SocketData {
        return ["username": username, "email": email, "password": password, "password2": password2]
    }
}
