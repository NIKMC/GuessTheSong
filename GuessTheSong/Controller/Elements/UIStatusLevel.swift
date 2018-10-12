//
//  UIStatusLevel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

@IBDesignable
final class UIStatusLevel: UIView {
    
    private var score = UILabel()
    private var statusLevelContainer = UIView()
    
    private var shapeLayer: CAShapeLayer! {
        didSet{
            shapeLayer.lineWidth = 7
            shapeLayer.lineCap = "round"
            shapeLayer.fillColor = nil
            shapeLayer.strokeEnd = 1
            shapeLayer.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        }
    }
    private var progressShapeLayer: CAShapeLayer! {
        didSet{
            progressShapeLayer.lineWidth = 7
            progressShapeLayer.lineCap = "round"
            progressShapeLayer.fillColor = nil
            progressShapeLayer.strokeEnd = 0
            progressShapeLayer.strokeColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1).cgColor
            progressShapeLayer.shadowOffset = CGSize(width: 2, height: 0)
            progressShapeLayer.shadowOpacity = 1
            progressShapeLayer.shadowRadius = 1
            progressShapeLayer.shadowColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1).cgColor
        }
    }
  
    
    @IBInspectable var fontSize: CGFloat = 14.0 {
        didSet {
            score.font = textFont
        }
    }
    
    private var textFont: UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    
    @IBInspectable var text: String? {
        get { return score.text  }
        set { score.text = newValue }
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
    
    init(frame: CGRect = CGRect.zero, score: Int, progress: Double) {
        super.init(frame: frame)
        commonInit(frame: frame)
        applyStyle()
        setScore(score: score)
        setProgress(currentProgress: progress)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit(frame: frame)
        applyStyle()
    }
    
    private func commonInit(frame: CGRect) {
        backgroundColor = .clear
        
        score.textAlignment = .center
        score.numberOfLines = 1
        score.textColor = #colorLiteral(red: 0.8100770116, green: 0.6858032346, blue: 0.2520789504, alpha: 1)
        
        statusLevelContainer.backgroundColor = .clear
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configShapeLayerLevel(shapeLayer, frame: statusLevelContainer.bounds)
        configShapeLayerLevel(progressShapeLayer, frame: statusLevelContainer.bounds)
        
    }
    
    private func applyStyle() {
        addSubview(score)
        score.translatesAutoresizingMaskIntoConstraints = false
        score.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        score.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        score.topAnchor.constraint(equalTo: topAnchor).isActive = true
        score.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        shapeLayer = CAShapeLayer()
        statusLevelContainer.layer.addSublayer(shapeLayer)
        progressShapeLayer = CAShapeLayer()
        statusLevelContainer.layer.addSublayer(progressShapeLayer)
        
        
        
        addSubview(statusLevelContainer)
        statusLevelContainer.translatesAutoresizingMaskIntoConstraints = false
        statusLevelContainer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        statusLevelContainer.heightAnchor.constraint(equalToConstant: 7).isActive = true
        statusLevelContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        statusLevelContainer.leadingAnchor.constraint(equalTo: score.trailingAnchor, constant: 0).isActive = true
        statusLevelContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        statusLevelContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        
        setProgress(currentProgress: 0.5)
        
    }
    
    
    private func configShapeLayerLevel(_ shapeLayer: CAShapeLayer, frame container: CGRect) {
        shapeLayer.frame = container
        let path = UIBezierPath()
        path.move(to: CGPoint(x: container.origin.x + 5, y: container.midY))
        path.addLine(to: CGPoint(x: container.size.width - 5, y: container.midY))
        shapeLayer.path = path.cgPath
    }
    
    func setScore(score: Int) {
        self.score.text = String(describing: score)
        setNeedsUpdateConstraints()
    }

    func setProgress(currentProgress: Double) {
        progressShapeLayer.strokeEnd = CGFloat(currentProgress)
    }
    
}



