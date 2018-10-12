//
//  BaseView.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 16/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

@IBDesignable
open class BaseView : UIView {
    
    override public init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        self.configureLayers()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayers()
    }
    
    /// Configure the Layers
    func configureLayers() {
        notifyViewRedesigned()
    }
    
    @IBInspectable open var background: UIColor = .clear {
        didSet {
            self.notifyViewRedesigned()
        }
    }
    
    @IBInspectable open var foreground: UIColor = .clear {
        didSet {
            self.notifyViewRedesigned()
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.notifyViewRedesigned()
        }
    }
    
    /// Call when any IBInspectable variable is changed
    func notifyViewRedesigned() {
        self.layer.backgroundColor = background.cgColor
        self.layer.cornerRadius = cornerRadius
    }
}
