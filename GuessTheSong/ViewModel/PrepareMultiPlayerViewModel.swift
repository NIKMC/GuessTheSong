//
//  PrapareMultiPlayerViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 16/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import Alamofire

protocol SocketBehaviourDelegate: class {
    
    func socketIsConnected()
    
    func startingGame()
    
    func updateReadyUsers(userId: Int, name: String)
}

class PrepareMultiPlayerViewModel: SocketBehaviourDelegate {
    
    
    private var musicsPath: [Int:URL]
    private var group: DispatchGroup
    private var fullMusics: [SongResponse]
    private var websocketURL: String?
    private var websocket: WebSocketManager?
    private var token: String
    private var levelNetworkManager: MultiPlayerJoinOperation?
    private var gameId: Int?
    private var players: [Player]
    private var selfID: Int
    var errorHandlerMessage: String?
    private(set) var status: Bool = false
    init() {
        self.musicsPath = [:]
        self.fullMusics = []
        self.players = []
        self.group = DispatchGroup()
        self.token = UserDefaults.standard.string(forKey: "token")!
        self.selfID = UserDefaults.standard.integer(forKey: "username_id")
    }
    
    func getStatusLevel() -> (Int, Double) {
        guard let level = UserDefaults.standard.string(forKey: "multi_player_experience") else {
            return (0, 0)
        }
        let value = Int(level)!
        let score = value / 10
        let progress: Double = (Double(value % 10)/10)
        //        let score = Int(floor(value))
        //        let progress = Double(value.truncatingRemainder(dividingBy: 1)).rounded()
        return (score, progress)
    }
    
    func prepareDataForStartGame(errorHandle: ((String) -> ())?) {
        print("prepareDataForStartGame")
        joinToMultiplayer(completion: { [weak self] (multiPlayerResponse) in
            self?.websocketURL = multiPlayerResponse.websocket_url
            self?.websocket = WebSocketManager(url: (self?.websocketURL)!, token: (self?.token)!, delegate: self!)
            self?.gameId = multiPlayerResponse.game.id
            self?.fullMusics.removeAll()
            let listOfSongs = multiPlayerResponse.game.songs
            print(multiPlayerResponse.game.users)
            let allPlayers = multiPlayerResponse.game.users.map { Player(id: $0.id, name: $0.username) }
            self?.players.append(contentsOf: allPlayers.filter { [weak self] in $0.getId() != self?.selfID })
            
            for user in (self?.players)! {
                print("the username is \(user.getName()) and id: \(user.getId())")
            }
//            multiPlayerResponse.game.users.map{print("the username is \($0.username) and id: \($0.id)")}
//            multiPlayerResponse.game.success_players.map{print("the success_players players is \($0.username) and id: \($0.id)")}
//            multiPlayerResponse.game.ready_players.map{print("the ready players is: \($0)")}
            print("The count of players is \(multiPlayerResponse.game.number_of_players)")
            self?.fullMusics.append(contentsOf: listOfSongs)
        }) { (error) in
            print("error of join to multi player")
            errorHandle?(error)
        }
    }
    
    
    
    func socketIsConnected() {
        downloadMusic(musics: fullMusics, completion: { [weak self] in
            self?.websocket?.downloadedMusic()
        }, errorHandle: { [weak self] (errorMessage) in
            print("error of loading or downloading songs")
            self?.errorHandlerMessage = errorMessage
            NotificationCenter.default.post(name: .socket, object: self)
        })
    }
    
    func startingGame() {
        status = true
        websocket?.deinitObserver()
        NotificationCenter.default.post(name: .socket, object: self)
    }
    
    func updateReadyUsers(userId: Int, name username: String) {
        let contains = players.contains { $0.getId() == userId }
        if !contains && userId != selfID {
            players.append(Player(id: userId, name: username))
        }
    }
    
    
    
    func joinToMultiplayer(completion: ((MultiPlayerResponse) -> ())?, errorHandle: ((String) -> ())?) {
        print("joinToMultiplayer with token \(token)")
        levelNetworkManager = MultiPlayerJoinOperation(token: token)
        levelNetworkManager?.start()
        levelNetworkManager?.success = { (multiPlayerResponse) in
            print("the result of join in multiplayer is ok \(multiPlayerResponse.websocket_url)")
            completion?(multiPlayerResponse)
        }
        
        levelNetworkManager?.failure = { (error) in
            print("error of loading info about multiplayer game \(error.localizedDescription)")
            ErrorValidator().chooseActionAfterResponse(errorResponse: error, success: { [weak self] () in
                self?.joinToMultiplayer(completion: completion, errorHandle: errorHandle)
                }, failure: { (errorMessage) in
                    errorHandle?(errorMessage.localizedDescription)
            })
        }
    }
    
    func downloadSong(taskInfo: SongResponse, destination destinationURL: URL, errorHandler: ((Error) -> ())?) {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let fileURL = destinationURL
            return (fileURL, [.createIntermediateDirectories])
        }
        
        let stringMusicUrl = taskInfo.getSongURL()
        
        let api = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
        let urlString = api + stringMusicUrl
        guard let url = URL(string: urlString) else { return }
        let editUrl = URL(string: url.absoluteString.replacingOccurrences(of: "http://terra.co.il/", with: "http://terra.co.il:41000/"))!
        Alamofire.download(editUrl, to: destination).response { [unowned self] response in
            print(response)
            
            if response.error == nil, let responseMusicPath = response.destinationURL {
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: responseMusicPath, to: destinationURL)
                    
                    print("task info \(url.lastPathComponent)")
                    print("destinationURL.absoluteString \(destinationURL.lastPathComponent)")
                    
                    if url.lastPathComponent == destinationURL.lastPathComponent {
                        self.musicsPath[taskInfo.id] = destinationURL
                        self.group.leave()
                    }
                    print("File moved to documents folder")
                } catch let error as NSError {
                    print(error.localizedDescription)
                    errorHandler?(error)
                }
            } else {
                errorHandler?(response.error ?? NSError())
            }
        }
    }
    
    func downloadMusic(musics: [SongResponse], completion: (() -> ())?, errorHandle: ((String) -> ())?) {
        for task in musics {
            // create document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let stringMusicUrl = task.getSongURL()
            guard let url = URL(string: stringMusicUrl) else { return }
            // create destination file url
            let destinationUrl =  documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
            
            print(destinationUrl)
            //            DispatchQueue.global(qos: .userInitiated).async(group: group) { [weak self] in
            group.enter()
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                musicsPath[task.id] = destinationUrl
                group.leave()
            } else {
                downloadSong(taskInfo: task, destination: destinationUrl) { [weak self] (error) in
                    errorHandle?("The error of downloading song is \(error.localizedDescription)")
                    self?.group.leave()
                }
            }
            //            }
        }
        
        group.notify(queue: .main) { [unowned self] in
            print("The musics count is \(musics.count)")
            print("The musicsPath count is \(self.musicsPath.count)")
            if musics.count == self.musicsPath.count {
                completion?()
            } else {
                print("Something went WRONG!!!!!!!!!!!!")
                errorHandle?("Error of downloading songs. Try again!")
            }
        }

    }
    
    func sendMessage() {
        websocket?.updatedScore(score: 1)
    }
    
    func goToPlayMyltiPlayer() -> MultiPlayViewModel {
        print("The ready gamers without you count: \(self.players.count)")
        for player in self.players {
            print("The starting gamer is: \(player.getName()) - id: \(player.getId())")
        }
        let sortedSongs = musicsPath.sorted(by: {$0.key<$1.key})
        let songs = sortedSongs.map({$0.value})
        return MultiPlayViewModel(path: songs, id: gameId!, info: fullMusics, webSocket: websocket!,gamers: players, myId: selfID)
    }
    
    
}
