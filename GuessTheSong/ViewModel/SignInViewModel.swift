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
    private var networkManager: SignInOperation?
    
    func setLoginAndPassword(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func goToTheMenu() -> MenuModelType {
        return MenuViewModel()
    }
    
    func signUp() -> SignUpModelType {
        return SignUpViewModel()
    }
    
    func signIn(completion: ((String)->())?, errorHandle: ((String)->())?) {
        guard let email = email, let password = password else { return }
        
        networkManager = SignInOperation(username: email, password: password)
        networkManager?.start()
        networkManager?.success = { [unowned self] (token) in
            self.defaults.setValue(email, forKey: "user_email")
            self.defaults.setValue(password, forKey: "user_password")
            self.defaults.setValue(token, forKey: "token")
            completion?("authorization is success")
        }
        
        networkManager?.failure = { (error) in
            print(error.localizedDescription)
            errorHandle?(error.localizedDescription)
        }

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
