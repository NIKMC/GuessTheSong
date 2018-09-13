//
//  SignUpModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol SignUpModelType {
    
    func setData(email: String, login: String, password: String, passwordRep: String)
    
    func signUp(completion: ((SignUpResponse)->())?, errorHandle: ((String)->())?)
    
    func signIn() -> SignInModelType
    
    func buttonTextOk() -> String
}
