//
//  SignInResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 14/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class SignInResponse: Codable {
    var token: String
    
    init(token: String) {
        self.token = token
    }
}
