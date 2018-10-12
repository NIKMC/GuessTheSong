//
//  SinglePlayViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class SinglePlayViewModel: GamePlayModelType {
    
    
    var age: Box<String?> = Box(nil)
    var time: Box<String?> = Box(nil)
    var title: Box<String?> = Box(nil)
    var text: Box<String?> = Box(nil)
    var lives: Box<Int?> = Box(nil)
    
    var defaults = UserDefaults.standard
    

    private var actionFinishGame: TypeFinishGame?
//    private var webSocketManager: WebSocketManager?
//    private var players: [Player]?
    
    private var levelOfLive: Int
    private var pathOfSongs: [URL]
    private var dataOfLevel: [SongResponse]
    private var index: Int
    private var gameId: Int
    private var audioLayer: AudioPlayerLayer?
    private var listOfAnswers: [String]
    private var finishGameNetworkManager: FinishGameOperation?
    private var audioPlayerViewModel: AudioPlayerLayer
    
    func getButtonTitle() -> String {
        return NSLocalizedString("Go", comment: "")
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
        let answers = answers.map{ $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)}
        if results == answers {
            goToTheNextSong(next: {
                rightAnswersHandler?()
            }) { [unowned self] in
                let timeOfGame = 90 * self.countOfSongs()
                self.stopPlayMusic()
                self.sendWinRequest(gameId: self.gameId, time: timeOfGame, completion: { (finishGameResponse) in
                    winHandler?(self.currentLive())
                }, errorHandle: { (error) in
                    //FIXME: - need to add something to controll response/
                    
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
                        //FIXME: - need to add something to controll response/
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
            print("the result is ok \(gameInfo.experience)")
            if var experience = self.defaults.value(forKey: "single_player_experience") as? Int {
                experience += gameInfo.experience
                self.defaults.set(experience, forKey: "single_player_experience")
            } else {
                self.defaults.set(gameInfo.experience, forKey: "single_player_experience")
            }
            completion?(gameInfo)
        }
        
        finishGameNetworkManager?.failure = { (error) in
            print("error of sending win request  \(error)")
            ErrorValidator().chooseActionAfterResponse(errorResponse: error, success: { [weak self] () in
                self?.sendWinRequest(gameId: id, time: timeOfGame, completion: completion, errorHandle: errorHandle)
                }, failure: { (errorMessage) in
                    errorHandle?(errorMessage.localizedDescription)
            })
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
    
    
    init(path: [URL], id gameId: Int, info: [SongResponse]) {
        self.index = 0
        self.levelOfLive = 3
        self.pathOfSongs = path
        self.gameId = gameId
        self.dataOfLevel = info
        self.listOfAnswers = []
        audioPlayerViewModel = AudioPlayerLayer(urls: path)
    }

}

enum TypeFinishGame {
    case WinSingle, WinMulty, LoseSingle, LoseMulty
}
