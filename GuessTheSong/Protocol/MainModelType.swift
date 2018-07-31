//
//  MainModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol MainModelType {
    
    func loadData()
    
    func signIn() -> SignInModelType
    
    func signUp() -> SignUpModelType
    
    func signInFacebook()
    
    func signInGmail()
}
