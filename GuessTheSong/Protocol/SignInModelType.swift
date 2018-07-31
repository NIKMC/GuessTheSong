//
//  LoginModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol SignInModelType {
    
    func signIn()
    
    func loadLogin() -> String
    
    func loadPassword() -> String
}
