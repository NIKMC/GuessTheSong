//
//  FinishGameModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 08/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

protocol FinishGameModelType {
    
    func getBehaviour() -> TypeFinishGame
    
    func goToMenu() -> MenuModelType
    
    func goToPlayAgain() -> WaitingRoomMultiPlayModelType
    
    func getButtonTitle() -> String
    
    func getImage() -> UIImage
}
