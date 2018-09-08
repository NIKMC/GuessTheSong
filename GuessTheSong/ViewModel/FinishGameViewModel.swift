//
//  FinishGameViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 08/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

class FinishGameViewModel: FinishGameModelType {
    
    private var action: TypeFinishGame
    
    init(action: TypeFinishGame) {
        self.action = action
    }
    
    func getBehaviour() -> TypeFinishGame {
        return action
    }
    
    func goToMenu() -> MenuModelType {
        return MenuViewModel()
    }
    
    func goToPlayAgain() -> WaitingRoomMultiPlayModelType {
        return WaitingRoomMultiPlayViewModel()
    }
    
    func getButtonTitle() -> String {
        switch action {
        case .WinSingle:
            return NSLocalizedString("Ok", comment: "")
        case .WinMulty:
            return NSLocalizedString("Play again", comment: "")
        case .LoseSingle:
            return NSLocalizedString("Menu", comment: "")
        case .LoseMulty:
            return NSLocalizedString("Play again", comment: "")
        }
    }
    
    func getImage() -> UIImage {
        switch action {
        case .WinSingle:
            return UIImage(named: "win")!
        case .WinMulty:
            return UIImage(named: "win")!
        case .LoseSingle:
            return UIImage(named: "failed")!
        case .LoseMulty:
            return UIImage(named: "loose")!
        }
    }
    
    
}
