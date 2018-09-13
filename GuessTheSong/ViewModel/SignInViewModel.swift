//
//  LoginViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class SignInViewModel : SignInModelType {
    
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
        networkManager?.success = { (token) in
            UserDefaults.standard.setValue(email, forKey: "user_email")
            UserDefaults.standard.setValue(password, forKey: "user_password")
            UserDefaults.standard.setValue(token, forKey: "token")
            completion?("authorization is success")
        }
        
        networkManager?.failure = { (error) in
            print(error.localizedDescription)
            errorHandle?(error.localizedDescription)
        }

    }
    
    func loadLogin() -> String {
        guard let email = UserDefaults.standard.value(forKey: "user_email") as? String else { return "" }
        return email
    }
    
    func loadPassword() -> String {
        guard let password = UserDefaults.standard.value(forKey: "user_password") as? String else { return "" }
        return password
    }
    
    func buttonTextOk() -> String {
        return NSLocalizedString("Ok", comment: "")
    }
    
    
}
