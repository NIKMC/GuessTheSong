//
//  SinglePlayViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class SinglePlayViewModel: SinglePlayModelType {
    
    
    var age: Box<String?> = Box(nil)
    var time: Box<String?> = Box(nil)
    var title: Box<String?> = Box(nil)
    var text: Box<String?> = Box(nil)
    var lives: Box<Int?> = Box(nil)
    
    var defaults = UserDefaults.standard
    
    private var behaviour: TypeAction
    private var actionFinishGame: TypeFinishGame?
    
    private var levelOfLive: Int
    private var pathOfSongs: [URL]
    private var dataOfLevel: [SongResponse]
    private var index: Int
    private var gameId: Int
    private var audioLayer: AudioPlayerLayer?
    private var listOfAnswers: [String]
    private var finishGameNetworkManager: FinishGameOperation?
    private var audioPlayerViewModel: AudioPlayerLayer
    
    func getBehaviour() -> TypeAction {
        return behaviour
    }
    
    func setActionToFinishGame(action: TypeFinishGame) {
        self.actionFinishGame = action
    }
    
    func goToFinishGame() -> FinishGameModelType {
        return FinishGameViewModel(action: self.actionFinishGame!)
    }
    
    func goToTheMenu() -> MenuModelType {
        return MenuViewModel()
    }
    
    func decreaseLive(continuePlay: (()->())?, finishPlay: (()->())?) {
        self.levelOfLive = currentLive() - 1
        (self.levelOfLive) == 0 ? finishPlay?() : continuePlay?()
    }
    
    func currentLive() -> Int {
        return self.levelOfLive
    }
    
    func currentIndex() -> Int {
        return self.index
    }
    
    func countOfSongs() -> Int {
        return self.pathOfSongs.count
    }
    
    func chooseCurrentSong() -> URL? {
        guard countOfSongs() > currentIndex() else { return nil }
        let destination = pathOfSongs[currentIndex()]
        return destination
    }
    
    func goToTheNextSong(next: (()->())?, end:(()->())?) {
        self.index = currentIndex() + 1
        if dataOfLevel.count > currentIndex() {
            next?()
        } else {
            end?()
        }
    }
    
    func getCurrentCountOfAnswers() -> Int? {
        guard dataOfLevel.count > currentIndex() else { return nil }
        let count = dataOfLevel[currentIndex()].getListOfAnswers().count
        return count
    }
    
    func getCurrentText() -> String? {
        guard dataOfLevel.count > currentIndex() else { return nil }
        let text = dataOfLevel[currentIndex()].getText()
        return text

    }
    
    func getCurrentCorrectAnswers() -> [String]? {
        guard dataOfLevel.count > currentIndex() else { return nil }
        let answers = dataOfLevel[currentIndex()].getListOfAnswers().map{ $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)}
        return answers
    }
    
    func compareAnswersWithResults(answers: [String], rightAnswersHandler: (()->())?, wrongAnswersHandler: ((Int)->())?, winHandler: ((Int)->())?, loseHandler: ((Int)->())?) {
        guard let results = getCurrentCorrectAnswers() else { return }
        if results == answers {
            goToTheNextSong(next: {
                rightAnswersHandler?()
            }) { [unowned self] in
                let timeOfGame = 90 * self.countOfSongs()
                self.stopPlayMusic()
                self.sendWinRequest(gameId: self.gameId, time: timeOfGame, completion: { (finishGameResponse) in
                    winHandler?(self.currentLive())
                }, errorHandle: { (error) in
                    //TODO: - need to add something to controll response/
                })
            }
        } else {
            decreaseLive(continuePlay: { [unowned self] in
                self.goToTheNextSong(next: {
                    wrongAnswersHandler?(self.currentLive())
                }, end: { [unowned self] in
                    let timeOfGame = 90 * self.countOfSongs()
                    self.stopPlayMusic()
                    self.sendWinRequest(gameId: self.gameId, time: timeOfGame, completion: { (finishGameResponse) in
                        winHandler?(self.currentLive())
                    }, errorHandle: { (error) in
                        //TODO: - need to add something to controll response/
                    })
                })
            }) {
                self.stopPlayMusic()
                loseHandler?(self.currentLive())
            }
        }
    }
    func sendWinRequest(gameId id: Int, time timeOfGame: Int, completion: ((FinishGameResponse)->())?, errorHandle: ((String)->())?) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            errorHandle?("Error update token")
            return
        }
        finishGameNetworkManager = FinishGameOperation(token: token, gameId: id, time: timeOfGame)
        finishGameNetworkManager?.start()
        finishGameNetworkManager?.success = { (gameInfo) in
            print("the result is ok \(gameInfo)")
            self.defaults.set(gameInfo.single_player_experience, forKey: "single_player_experience")
            completion?(gameInfo)
        }
        
        finishGameNetworkManager?.failure = { (error) in
            print("error of loading indfo about level \(error)")
            errorHandle?(error.localizedDescription)
        }
    }
    
    func startGame() {
        startPlayMusic()
    }
    
    func stopGame() {
        audioPlayerViewModel.pausePlay()
    }
    
    func startPlayMusic() {
        audioPlayerViewModel.playMusic()
    }
    
    func stopPlayMusic() {
        audioPlayerViewModel.pausePlay()
    }
    
    
    init(action: TypeAction, path: [URL], id gameId: Int, info: [SongResponse]) {
        self.behaviour = action
        self.index = 0
        self.levelOfLive = 3
        self.pathOfSongs = path
        self.gameId = gameId
        self.dataOfLevel = info
        self.listOfAnswers = []
        audioPlayerViewModel = AudioPlayerLayer(urls: path)
//        print(path)
//        print(info.first?.getNameOfSong())
    }
}

enum TypeAction {
    case Single, Multy
}

enum TypeFinishGame {
    case WinSingle, WinMulty, LoseSingle, LoseMulty
}
