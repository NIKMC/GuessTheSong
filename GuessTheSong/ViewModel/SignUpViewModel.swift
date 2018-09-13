//
//  SignUpViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class SignUpViewModel: SignUpModelType {
    
    private let defaults = UserDefaults.standard
    private var email: String?
    private var login: String?
    private var password: String?
    private var passwordRep: String?
    private var networkManager: SignUpOperation?
    
    func setData(email: String, login: String, password: String, passwordRep: String) {
        self.email = email
        self.login = login
        self.password = password
        self.passwordRep = passwordRep
    }
    
    func signIn() -> SignInModelType {
        return SignInViewModel()
    }
    
    func buttonTextOk() -> String {
        return NSLocalizedString("Ok", comment: "")
    }
    
    func signUp(completion: ((SignUpResponse)->())?, errorHandle: ((String)->())?) {
        guard let email = email else { return }
        guard let login = login else { return }
        guard let password = password else { return }
        guard let passwordRep = passwordRep else { return }
        guard password == passwordRep else { return }
        
        networkManager = SignUpOperation(email: email, login: login, password: password, passwordRep: passwordRep)
        networkManager?.start()
        
        networkManager?.success = { (signUpResponse) in
//        self.defaults.setValue(signUpResponse, forKey: "token")
//        self.defaults.setValue(email, forKey: "user_email")
//        self.defaults.setValue(password, forKey: "user_password")
            print("email \(signUpResponse.email)")
            print("first_name \(signUpResponse.first_name)")
            print("last_name \(signUpResponse.last_name)")
            print("username \(signUpResponse.username)")
            print("single_player_experience \(signUpResponse.single_player_experience)")
            completion?(signUpResponse)
        }

        networkManager?.failure = { (error) in
            print("The error is \(error.localizedDescription)")
            errorHandle?(error.domain)
        }
    }
    
}
