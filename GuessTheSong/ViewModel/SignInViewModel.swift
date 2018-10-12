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
    
    func checkPasswordOnStrong(password: String, handlerSuccess: (()->())?, handlerFailure: ((String)->())?) {
        let passwordValidator = PasswordValidator.init(text: password).reliability
        if !passwordValidator.contains(.atLeastEightCharacters) {
            handlerFailure?(NSLocalizedString("The password is too short", comment: ""))
        } else {
            handlerSuccess?()
        }
    }
    
    func signIn(completion: ((String)->())?, errorHandle: ((String)->())?) {
        guard let email = email, let password = password else { return }
        
        networkManager = SignInOperation(username: email, password: password)
        networkManager?.start()
        networkManager?.success = {
            Session.shared.username = email
            Session.shared.password = password
            completion?("authorization is success")
        }
        
        networkManager?.failure = { (error) in
            print("Error of SignIn \(error.localizedDescription)")
            ErrorValidator().chooseActionAfterResponse(errorResponse: error, success: { () in
                completion?("authorization is success")
            }, failure: { (errorMessage) in
                errorHandle?(errorMessage.localizedDescription)
            })
        }

    }
    
    func loadLogin() -> String {
        guard let email = Session.shared.username else { return "" }
        return email
    }
    
    func loadPassword() -> String {
        guard let password = Session.shared.password else { return "" }
        return password
    }
    
    func buttonTextOk() -> String {
        return NSLocalizedString("Ok", comment: "")
    }
    
    
}
