//
//  AppDelegateEx.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 08/06/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
extension AppDelegate {
    
    class func isIPhoneSE () -> Bool{
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 568.0
    }
    class func isIPhone5 () -> Bool{
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 568.0
    }
    class func isIPhone6 () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 667.0
    }
    class func isIPhone6Plus () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 736.0
    }
}
