//
//  SinglePlayViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import Alamofire

class PrepareSinglePlayViewModel: PrepareGameModelType {
    
    private var level: Int
    private var gameId: Int
    private var levelNetworkManager: FullLevelOperation?
    private var musicsPath: [Int:URL]
    private var group: DispatchGroup
    private var fullLevelInfo: [SongResponse]
    
    init(level currentLevel: Int, idGame gameId: Int) {
        self.level = currentLevel
        self.gameId = gameId
        self.musicsPath = [:]
        self.fullLevelInfo = []
        print("the id is \(level)")
        self.group = DispatchGroup()
    }
    
    func prepareDataForStartGame(completion: (()->())?, errorHandle: ((String)->())?) {
        
        loadingLevel(completion: { [weak self] (levelInfo) in
            self?.fullLevelInfo.removeAll()
            let listOfSongs = levelInfo.songs
            self?.fullLevelInfo.append(contentsOf: listOfSongs)
            self?.downloadMusic(musics: listOfSongs, completion: {
                completion?()
            }, errorHandle: { (errorMessage) in
                print("error of loading or downloading songs")
                errorHandle?(errorMessage)
            })
        }) { (error) in
            print("error loading info about level")
            errorHandle?(error)
        }
        
        
    }
    
    func goToPlaySinglePlay() -> GamePlayModelType {
        let sortedSongs = musicsPath.sorted(by: {$0.key<$1.key})
        let songs = sortedSongs.map({$0.value})
        return SinglePlayViewModel(path: songs, id: gameId, info: fullLevelInfo)
    }
    
    
    func loadingLevel(completion: ((LevelResponse)->())?, errorHandle: ((String)->())?) {
        //FIXME: change on the Static class with variable token
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            errorHandle?("Error update token")
            return
        }
        levelNetworkManager = FullLevelOperation(token: token, levelId: level)
        levelNetworkManager?.start()
        levelNetworkManager?.success = { (levelInfo) in
            print("the result is ok \(levelInfo.name)")
            completion?(levelInfo)
        }
        
        levelNetworkManager?.failure = { (error) in
            print("error of loading indfo about level \(error)")
            ErrorValidator().chooseActionAfterResponse(errorResponse: error, success: { [weak self] () in
                self?.loadingLevel(completion: completion, errorHandle: errorHandle)
                }, failure: { (errorMessage) in
                    errorHandle?(errorMessage.localizedDescription)
            })
        }
    }
    
    func downloadSong(taskInfo: SongResponse, destination destinationURL: URL, errorHandler: ((Error)->())?) {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let fileURL = destinationURL
            return (fileURL, [.createIntermediateDirectories])
        }
        
        let stringMusicUrl = taskInfo.getSongURL()
        guard let url = URL(string: stringMusicUrl) else { return }
        let editUrl = URL(string: url.absoluteString.replacingOccurrences(of: "http://terra.co.il/", with: "http://terra.co.il:41000/"))!
        
        Alamofire.download(editUrl, to: destination).response { [unowned self] response in
            print(response)
            
            if response.error == nil, let responseMusicPath = response.destinationURL {
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: responseMusicPath, to: destinationURL)
                    
                    print("task info \(url.lastPathComponent)")
                    print("destinationURL.absoluteString \(destinationURL.lastPathComponent)")
                    
                    if editUrl.lastPathComponent == destinationURL.lastPathComponent {
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
   
    
    func downloadMusic(musics: [SongResponse], completion: (()->())?, errorHandle: ((String)->())?) {
        
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
                        errorHandle?(error.localizedDescription)
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
    
}
