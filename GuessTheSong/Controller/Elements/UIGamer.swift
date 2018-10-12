//
//  UIGamers.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 14/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

@IBDesignable
final class UIGamer: UIView {
    
    private var head = UILabel()
    private var round = UILabel()
    private var container = UIView()
//    var name: String
//    var score: Int
    
    @IBInspectable var fontSizeHead: CGFloat = 14.0 {
        didSet {
            head.font = textFont
        }
    }
    @IBInspectable var fontSizeRound: CGFloat = 12.0 {
        didSet {
            round.font = textFontRound
        }
    }
    
    private var textFont: UIFont {
        return UIFont.systemFont(ofSize: fontSizeHead, weight: .bold)
    }
    
    private var textFontRound: UIFont {
        return UIFont.systemFont(ofSize: fontSizeRound, weight: .medium)
    }
    
    @IBInspectable var textHead: String? {
        get { return head.text  }
        set { head.text = newValue }
    }
    @IBInspectable var text: String? {
        get { return round.text  }
        set { round.text = newValue }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit(frame: CGRect.zero)
        applyStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit(frame: frame)
        applyStyle()
    }
    
    init(frame: CGRect = CGRect.zero, name: String, value: Int) {
        super.init(frame: frame)
        commonInit(frame: frame)
        applyStyle()
        setName(username: name)
        setRoundSuccess(round: value)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit(frame: frame)
        applyStyle()
    }
    
    private func commonInit(frame: CGRect) {
        container.backgroundColor = .clear
        self.backgroundColor = #colorLiteral(red: 0.8100770116, green: 0.6858032346, blue: 0.2520789504, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        self.layer.cornerRadius = frame.size.width / 2
        self.layer.borderWidth = 1
        head.textAlignment = .center
        head.numberOfLines = 1
        head.backgroundColor = .clear
        head.textColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        round.textAlignment = .center
        round.numberOfLines = 1
        round.backgroundColor = .clear
        round.textColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        
        
    }
    
    
    
    private func applyStyle() {
        
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        container.addSubview(head)
        head.translatesAutoresizingMaskIntoConstraints = false
        head.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        head.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5).isActive = true
        head.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
        
        container.addSubview(round)
        round.translatesAutoresizingMaskIntoConstraints = false
        round.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        round.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5).isActive = true
        round.topAnchor.constraint(equalTo: head.bottomAnchor, constant: 0).isActive = true
        
    }
    
    func setName(username login: String) {
//        self.name = login
        let symbol = login.prefix(1).localizedUppercase
        print("The first symbol of login: \(login) - \(symbol)")
        self.head.text = symbol
    }
    
    func setRoundSuccess(round value: Int) {
//        self.score = value
        self.round.text = "+\(value)"
    }
    
    
}



