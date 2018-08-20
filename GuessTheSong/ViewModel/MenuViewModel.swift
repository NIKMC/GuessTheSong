//
//  MenuViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class MenuViewModel: MenuModelType {
    
    private let defaults = UserDefaults.standard
    private var networkManager: ProfileInfoOperation?
    
    
    func showProfileInfo(completion: ((ProfileResponse)->())?, errorHandle: ((String)->())?) {
        let token = defaults.value(forKey: "token") as! String
//        let userId = defaults.value(forKey: "id") as! String
        networkManager = ProfileInfoOperation(token: token)
        networkManager?.start()
        networkManager?.success = { (myProfile) in
            print("success get my profile")
            completion?(myProfile)
            
        }
        
        networkManager?.failure = { (error) in
            print("error of get profile = \(error)")
            errorHandle?(error.domain)
        }
        
    }
    
    func logOut(completion: ((String)->())?, errorHandle: ((String)->())?) {
        
    }
    
    func singlePlay() {
        
    }
    
    func multyPlay() {
        
    }
    
    
}
