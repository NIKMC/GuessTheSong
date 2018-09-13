//
//  MainViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class MainViewModel: NSObject, MainModelType {
    
    func loadData() {
        
    }
    
    func signIn() -> SignInModelType {
        return SignInViewModel()
    }
    
    func signUp() -> SignUpModelType {
        return SignUpViewModel()
    }
    
    
    func signInFacebook() {
        
    }
    
    func signInGmail() {
        
    }
    
    func buttonTextLogin() -> String {
        return NSLocalizedString("Login", comment: "")
    }
    func buttonTextRegistration() -> String {
        return NSLocalizedString("Registration", comment: "")
    }
    func buttonTextFB() -> String {
        return NSLocalizedString("Sign in with Facebook", comment: "")
    }
    func buttonTextGmail() -> String {
        return NSLocalizedString("Sign in with Gmail", comment: "")
    }
    
    
    
}
