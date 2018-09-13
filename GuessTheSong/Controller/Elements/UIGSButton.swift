//
//  UIGSButton.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 13/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

@IBDesignable
final class UIGSButton: UIView {

    private let button = UIButton(type: .custom)
    private let leftImageView = UIImageView()
    
    enum Style: Int {
        case none = 0
        case normal
        case rich
        case facebook
        case gmail
        case round
    }
    
    var style: Style = .normal {
        didSet { applyStyle() }
    }
    
    var leftImageWidthConstraint: NSLayoutConstraint?
    var leftImageHeightConstraint: NSLayoutConstraint?
    
    var handler: ((UIGSButton) -> ())?
    
    @IBInspectable private var styleType: Int {
        get { return style.rawValue }
        
        set {
            if let newStyle = Style(rawValue: newValue) {
                style = newStyle
            }
        }
    }
    
    @IBInspectable private var leftImage: UIImage? {
        didSet {
            leftImageView.image = leftImage
        }
    }
    
    @IBInspectable private var leftImageSize: CGSize = CGSize(width: 20, height: 20) {
        didSet {
            leftImageWidthConstraint?.constant = leftImageSize.width
            leftImageHeightConstraint?.constant = leftImageSize.height
            setNeedsUpdateConstraints()
            
        }
        
    }
    @IBInspectable private var fontSize: CGFloat = 20.0 {
        didSet {
            button.titleLabel?.font = textFont
        }
    }
    
    @IBInspectable private var cornerRadius: CGFloat = 20.0 {
        didSet {
            button.layer.cornerRadius = cornerRadius
        }
    }
    
    private var textFont: UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    @IBInspectable var text: String? {
        get { return button.title(for: .normal)  }
        set { button.setTitle(newValue, for: .normal) }
    }
    
    
    @available(*, unavailable, message: "Use init(frame: CGRect, style: Styles) instead")
    init() {
        fatalError("Use another init")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        applyStyle()
    }
    
    init(frame: CGRect = CGRect.zero, style: Style) {
        super.init(frame: frame)
        commonInit()
        self.style = style
        applyStyle()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        applyStyle()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        //Button
        addSubview(button)
        
        button.addTarget(self, action: #selector(didtapButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        //LeftImageView
        addSubview(leftImageView)
        
        leftImageView.image = leftImage
        leftImageView.contentMode = .scaleAspectFit
        
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        leftImageWidthConstraint = leftImageView.widthAnchor.constraint(equalToConstant: leftImageSize.width)
        leftImageWidthConstraint?.isActive = true
        
        leftImageHeightConstraint = leftImageView.heightAnchor.constraint(equalToConstant: leftImageSize.height)
        leftImageHeightConstraint?.isActive = true
        
    }
    
    private func applyStyle() {
        switch style {
        case .none:
            button.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
            button.titleLabel?.font = textFont
            button.layer.borderWidth = 1
        case .normal:
            button.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
            button.layer.borderColor = #colorLiteral(red: 0.8100770116, green: 0.6858032346, blue: 0.2520789504, alpha: 1)
            button.titleLabel?.font = textFont
            button.layer.cornerRadius = cornerRadius
            button.layer.borderWidth = 1
            button.setTitleColor(.white, for: .normal)
            button.layer.shadowColor = #colorLiteral(red: 0.8100770116, green: 0.6858032346, blue: 0.2520789504, alpha: 1)
            button.layer.shadowOffset = CGSize(width: 0, height: 0)
            button.layer.shadowOpacity = 0.8
            button.layer.shadowRadius = 10
        case .rich:
            button.backgroundColor = #colorLiteral(red: 0.8100770116, green: 0.6858032346, blue: 0.2520789504, alpha: 1)
            button.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            button.titleLabel?.font = textFont
            button.layer.cornerRadius = cornerRadius
            button.layer.borderWidth = 1
            button.setTitleColor(.black, for: .normal)
            button.layer.shadowColor = UIColor.clear.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 0)
            button.layer.shadowOpacity = 0
            button.layer.shadowRadius = 0
        case .facebook:
            button.backgroundColor = #colorLiteral(red: 0.2352941176, green: 0.3529411765, blue: 0.6, alpha: 1)
            button.layer.borderColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
            button.titleLabel?.font = textFont
            button.layer.cornerRadius = cornerRadius
            button.layer.borderWidth = 1
            button.setTitleColor(.white, for: .normal)
            button.layer.shadowColor = UIColor.clear.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 0)
            button.layer.shadowOpacity = 0
            button.layer.shadowRadius = 0
        case .gmail:
            button.backgroundColor = #colorLiteral(red: 0.7921568627, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
            button.layer.borderColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
            button.titleLabel?.font = textFont
            button.layer.cornerRadius = cornerRadius
            button.layer.borderWidth = 1
            button.setTitleColor(.white, for: .normal)
            button.layer.shadowColor = UIColor.clear.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 0)
            button.layer.shadowOpacity = 0
            button.layer.shadowRadius = 0
        case .round:
            button.backgroundColor = #colorLiteral(red: 0.8100770116, green: 0.6858032346, blue: 0.2520789504, alpha: 1)
            button.layer.borderColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
            button.titleLabel?.font = textFont
            button.layer.cornerRadius = cornerRadius
            button.layer.borderWidth = 1
            button.setTitleColor(.black, for: .normal)
            button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 25)
        }
    }
    
}

extension UIGSButton {
    
    @objc private func didtapButton() {
        self.alpha = 0.5
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.alpha = 1.0
        }) { [weak self] (_) in
            if self != nil {
                self!.handler?(self!)
            }
        }
    }
}
