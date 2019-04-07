//
//  MultiPlayViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 26/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol MultiPlaySocketBehaviourDelegate: SocketBehaviourDelegate {
    
    func scoreOfPlayerWasUpdated(score: Int, userId: Int)
    
    func finishedGameSuccessfully(userId: Int, experience: Double)
    
    func finishedGameFailure(userId: Int)
    
}


class MultiPlayViewModel: MultiPlaySocketBehaviourDelegate {
    
    var age: Box<String?> = Box(nil)
    var time: Box<String?> = Box(nil)
    var title: Box<String?> = Box(nil)
    var text: Box<String?> = Box(nil)
    var lives: Box<Int?> = Box(nil)
    
    var defaults = UserDefaults.standard
    
    
    private var actionFinishGame: TypeFinishGame?
    private var webSocketManager: WebSocketManager?
    private var players: [Player]
    
    private var levelOfLive: Int
    private var pathOfSongs: [URL]
    private var dataOfLevel: [SongResponse]
    private var index: Int
    private var gameId: Int
    private var myId: Int
    private var audioLayer: AudioPlayerLayer?
    private var listOfAnswers: [String]
    private var audioPlayerViewModel: AudioPlayerLayer
    var successFinish = false
    
    func countOfGamers() -> Int {
        return players.count
    }
    
    func itemOfPlayer(index: Int) -> Player {
        return players[index]
    }
    
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
    
    
    //FIXME: - change this method with socket
    func compareAnswersWithResults(answers: [String], rightAnswersHandler: (()->())?, wrongAnswersHandler: ((Int)->())?, loseHandler: ((Int)->())?) {
        guard let results = getCurrentCorrectAnswers() else { return }
        if results == answers {
            goToTheNextSong(next: { [unowned self] in
                rightAnswersHandler?()
                self.webSocketManager?.updatedScore(score: self.currentIndex())
            }) { [weak self] in
                self?.stopPlayMusic()
                self?.sendWinRequest(
//                    completion: { () in
//                    winHandler?((self?.currentLive())!)
//                }
                )
            }
        } else {
            decreaseLive(continuePlay: { [unowned self] in
                self.goToTheNextSong(next: {
                    wrongAnswersHandler?(self.currentLive())
                }, end: { [weak self] in
                    self?.stopPlayMusic()
                    self?.sendWinRequest(
//                        completion: { () in
//                        winHandler?((self?.currentLive())!)
//                    }
                    )
                })
            }) {
                self.stopPlayMusic()
                loseHandler?(self.currentLive())
            }
        }
    }
    
    func finishGame() {
        webSocketManager?.deinitObserver()
    }
    
    func sendWinRequest() {
        webSocketManager?.finishGameSuccess()
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
    
    
    init(path: [URL], id gameId: Int, info: [SongResponse], webSocket: WebSocketManager, gamers players: [Player], myId selfID: Int) {
        self.index = 0

        self.levelOfLive = 3
        self.pathOfSongs = path
        self.gameId = gameId
        self.dataOfLevel = info
        self.listOfAnswers = []
        self.audioPlayerViewModel = AudioPlayerLayer(urls: path)
        self.webSocketManager = webSocket
        self.players = players
        self.myId = selfID
        self.webSocketManager?.setObserver(selfObserver: self)
    }
    
    func socketIsConnected() {
        print("socked is connected in MultiPlayViewModel")
    }
    
    func startingGame() {
        print("socked starting game in MultiPlayViewModel")
    }
    
    func updateReadyUsers(userId: Int, name: String) {
        print("socked update user status is ready in MultiPlayViewModel")
    }
    //FIXME: - prepare functions to update UIGamers if gamer score has been updated
    func scoreOfPlayerWasUpdated(score: Int, userId: Int) {
        if userId != myId {
            let result = players.contains(where: { (gamer) -> Bool in
                if gamer.getId() == userId {
                    gamer.updateRating(newValue: score)
                    return true
                } else { return false }
            })
            if result {
                NotificationCenter.default.post(name: .socket, object: self)
            }
        }
    }
    
    func finishedGameSuccessfully(userId: Int, experience: Double) {
        if userId == myId {
            print("the experience in the game: \(experience)")
            if var multiExperience = self.defaults.value(forKey: "multi_player_experience") as? Double {
                multiExperience += experience
                self.defaults.set(multiExperience, forKey: "multi_player_experience")
            } else {
                self.defaults.set(experience, forKey: "multi_player_experience")
            }
            successFinish = true
            webSocketManager?.deinitObserver()
            NotificationCenter.default.post(name: .socket, object: self)
        }
    }
    
    func finishedGameFailure(userId: Int) {
        if userId != myId {
            let updatePlayers = players.filter { $0.getId() !=  userId}
            players.removeAll()
            players.append(contentsOf: updatePlayers)
            NotificationCenter.default.post(name: .socket, object: self)
        }
    }
    
    
}
