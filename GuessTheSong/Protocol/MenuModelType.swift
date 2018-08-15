//
//  MenuModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol MenuModelType {
    
    func showProfileInfo(completion: ((UserProfile)->())?, errorHandle: ((String)->())?)
    
    func logOut(completion: ((String)->())?, errorHandle: ((String)->())?)
    
    func singlePlay()
    
    func multyPlay()
}
