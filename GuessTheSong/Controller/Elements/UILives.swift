//
//  UILives.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 31/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

@IBDesignable
final class UILives: UIView {

    private let firstImageView = UIImageView()
    private let secondImageView = UIImageView()
    private let thirdImageView = UIImageView()
    
    enum TypeLive: Int {
        case empty = 0
        case oneLive
        case twoLive
        case full
    }
    
    var type: TypeLive = .empty {
        didSet { applyStyle() }
    }
    
    @IBInspectable private var styleType: Int {
        get { return type.rawValue }
        
        set {
            if let newStyle = TypeLive(rawValue: newValue) {
                type = newStyle
            }
        }
    }
    
    @IBInspectable private var liveImage: UIImage? {
        didSet {
            firstImageView.image = liveImage
            secondImageView.image = liveImage
        }
    }
    
    @IBInspectable private var noLiveImage: UIImage? {
        didSet {
            thirdImageView.image = noLiveImage
        }
    }
    private var imageSize: CGSize = CGSize(width: 20, height: 30)
    
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
        applyStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        applyStyle()
    }
    
    init(frame: CGRect = CGRect.zero, style: TypeLive) {
        super.init(frame: frame)
        commonInit()
        self.type = style
        applyStyle()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        applyStyle()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        addSubview(firstImageView)
        firstImageView.contentMode = .scaleAspectFit
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        
        firstImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        firstImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        firstImageView.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
        firstImageView.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
        
    
        addSubview(secondImageView)
        secondImageView.contentMode = .scaleAspectFit
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        
        secondImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        secondImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        secondImageView.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
        secondImageView.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true

        
        addSubview(thirdImageView)
        thirdImageView.contentMode = .scaleAspectFit
        thirdImageView.translatesAutoresizingMaskIntoConstraints = false
        
        thirdImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        thirdImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        thirdImageView.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
        thirdImageView.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
        
        
    }
    
    func setLives(_ lives: Int) {
        if let newStyle = TypeLive(rawValue: lives) {
            type = newStyle
        } else { return }
        switch type {
        case .empty:
            firstImageView.image = noLiveImage
            secondImageView.image = noLiveImage
            thirdImageView.image = noLiveImage
            
        case .oneLive:
            firstImageView.image = liveImage
            secondImageView.image = noLiveImage
            thirdImageView.image = noLiveImage
        case .twoLive:
            firstImageView.image = liveImage
            secondImageView.image = liveImage
            thirdImageView.image = noLiveImage
        case .full:
            firstImageView.image = liveImage
            secondImageView.image = liveImage
            thirdImageView.image = liveImage
        }
    }
    
    private func applyStyle() {

        switch type {
        case .empty:
            firstImageView.image = noLiveImage
            secondImageView.image = noLiveImage
            thirdImageView.image = noLiveImage

        case .oneLive:
            firstImageView.image = liveImage
            secondImageView.image = noLiveImage
            thirdImageView.image = noLiveImage
        case .twoLive:
            firstImageView.image = liveImage
            secondImageView.image = liveImage
            thirdImageView.image = noLiveImage
        case .full:
            firstImageView.image = liveImage
            secondImageView.image = liveImage
            thirdImageView.image = liveImage
        }
    }

    
    

}
