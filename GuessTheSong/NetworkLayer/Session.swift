//
//  Session.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 26/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class Session {
    static let shared = Session()
    
    var access_token: String? {
        get {
            let token = UserDefaults.standard.string(forKey: "token")
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
    var username: String? {
        get {
            let token = UserDefaults.standard.string(forKey: "user_email")
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "user_email")
        }
    }
    var password: String? {
        get {
            let token = UserDefaults.standard.string(forKey: "user_password")
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "user_password")
        }
    }
    
}
