//
//  UIGamers.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

@IBDesignable
final class UIGamers: UIView {
    
    private var users: [UIGamer] = []
    private var players: [Player] = []
    
//    var count: Int = 0 {
//        didSet { applyStyle(gamers: nil) }
//    }
//    
    
    
    var handlerDone: (() -> ())?
    
    
//    @IBInspectable var countTextField: Int {
//        get { return count }
//
//        set { count = newValue }
//
//    }
//
    
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
        applyStyle(gamers: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        applyStyle(gamers: nil)
    }
    
    init(frame: CGRect = CGRect.zero, players: [Player]) {
        super.init(frame: frame)
        commonInit()
//        self.count = players.count
        applyStyle(gamers: players)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        applyStyle(gamers: nil)
    }
    
    private func commonInit() {
        clipsToBounds = true
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print(<#T##items: Any...##Any#>)
    }
    
    
    private func applyStyle(gamers: [Player]?) {
        if var gamers = gamers {
            gamers.sort { $0.getRating() > $1.getRating() }
            players = gamers
            for (index, indexOfGamer) in gamers.enumerated() {
                let gamer = UIGamer(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 40, height: 40)) , name: "\(indexOfGamer.getName())", value: indexOfGamer.getRating())
                let leadConstraint = CGFloat((index * 40) + (5 * index))
                print("the lead constraint \(leadConstraint) - on the \(index) itteration")
                print("the frame size \(self.layer.bounds.size.width)")
                addSubview(gamer)
                gamer.translatesAutoresizingMaskIntoConstraints = false
                gamer.widthAnchor.constraint(equalToConstant: 40).isActive = true
                gamer.heightAnchor.constraint(equalToConstant: 40).isActive = true
                gamer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadConstraint).isActive = true
                gamer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                gamer.fontSizeHead = 14
                gamer.fontSizeRound = 12
                users.append(gamer)
            }
        }
        
       
    }
    
    func initCurrentGamers(gamers: [(Player, Int)]) {
        if users.count == gamers.count {
            print("The counts equel")
            for (index, gamer) in gamers.enumerated() {
                users[index].setName(username: gamer.0.getName())
                users[index].setRoundSuccess(round: gamer.1)
            }
        }
    }
    
    func updateUIAnswers(players gamers: [Player]) {
        users.removeAll()
        for view in self.subviews{
            view.removeFromSuperview()
        }
        applyStyle(gamers: gamers)
        
    }
    
    
}
