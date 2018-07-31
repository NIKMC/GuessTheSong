//
//  LoginViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class SignInViewModel : SignInModelType {
    
    private let defaults = UserDefaults.standard
    private var email: String?
    private var password: String?
    
    func signIn() {
        
    }
    
    func loadLogin() -> String {
        guard let email = defaults.value(forKey: "user_email") as? String else { return "" }
        return email
    }
    
    func loadPassword() -> String {
        guard let password = defaults.value(forKey: "user_password") as? String else { return "" }
        return password
    }
    
    
}
