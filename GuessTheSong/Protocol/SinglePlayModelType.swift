//
//  SinglePlayModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol SinglePlayModelType {
    
    var time: Box<String?> { get }
    var title: Box<String?> { get }
    var text: Box<String?> { get }
    var lives: Box<Int?> { get }
    
    func getBehaviour() -> TypeAction
    
    func setActionToFinishGame(action: TypeFinishGame)
    
    func goToFinishGame() -> FinishGameModelType
    
    func goToTheMenu() -> MenuModelType
    
    func decreaseLive(continuePlay: (()->())?, finishPlay: (()->())?)
    
    func currentLive() -> Int
    
    func currentIndex() -> Int
    
    func countOfSongs() -> Int
    
    func chooseCurrentSong() -> URL?
    
    func goToTheNextSong(next: (()->())?, end:(()->())?)
    
    func getCurrentCountOfAnswers() -> Int?
    
    func getCurrentText() -> String?
    
    func getCurrentCorrectAnswers() -> [String]?
    
    func compareAnswersWithResults(answers: [String], rightAnswersHandler: (()->())?, wrongAnswersHandler: ((Int)->())?, winHandler: ((Int)->())?, loseHandler: ((Int)->())?)
    
    func startGame()
    
    func stopGame()
}
