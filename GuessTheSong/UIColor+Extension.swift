//
//  UIColor+Extension.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(white: 0, alpha: 1.0)
        } else {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: CGFloat(1.0))
        }
    }
    
    static var rich: UIColor {
        return UIColor(hex: "C3A132")
    }
    
    static var weakrich: UIColor {
        return UIColor(hex: "C3A132").withAlphaComponent(0.4)
    }
    
    static var errorRedBg: UIColor {
        return UIColor(hex: "E42014").withAlphaComponent(0.2)
    }
    
}
