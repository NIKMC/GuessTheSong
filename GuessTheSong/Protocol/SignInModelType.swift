//
//  LoginModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol SignInModelType {
    
    func setLoginAndPassword(email mail: String, password pass: String)
    
    func signIn(completion: ((Profile)->())?, errorHandle: ((String)->())?)
    
    func goToTheMenu() -> MenuModelType
    
    func signUp() -> SignUpModelType
    
    func loadLogin() -> String
    
    func loadPassword() -> String
}
