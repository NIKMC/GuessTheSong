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
    
    
    func showProfileInfo(completion: (()->())?, errorHandle: ((String)->())?) {
        let token = defaults.value(forKey: "token") as! String
        networkManager = ProfileInfoOperation(token: token)
        networkManager?.start()
        networkManager?.success = { [unowned self] (myProfile) in
            print("success get my profile")
            print("The my ID after sign in is \(myProfile.id)")
            self.defaults.set(myProfile.username, forKey: "username")
            self.defaults.set(myProfile.id, forKey: "username_id")
            self.defaults.set(myProfile.first_name, forKey: "first_name")
            self.defaults.set(myProfile.last_name, forKey: "last_name")
            self.defaults.set(myProfile.email, forKey: "email")
            self.defaults.set(myProfile.single_player_experience, forKey: "single_player_experience")
            self.defaults.set(myProfile.multi_player_experience, forKey: "multi_player_experience")
            completion?()
        }
        
        networkManager?.failure = { (error) in
            print("error of get profile = \(error.localizedDescription)")
            ErrorValidator().chooseActionAfterResponse(errorResponse: error, success: { [weak self] () in
                self?.showProfileInfo(completion: completion, errorHandle: errorHandle)
            }, failure: { (errorMessage) in
                errorHandle?(errorMessage.localizedDescription)
            })
        }
        
    }
    
    func logOut(completion: ((String)->())?, errorHandle: ((String)->())?) {
        
    }
    
    func singlePlay() {
        
    }
    
    func multiPlay() -> PrepareMultiPlayerViewModel {
        return PrepareMultiPlayerViewModel()
    }
    
    func buttonTextSingle() -> String {
        return NSLocalizedString("Single Player", comment: "")
    }
    func buttonTextMulty() -> String {
        return NSLocalizedString("Multiplayer", comment: "")
    }
    
    
    
}
