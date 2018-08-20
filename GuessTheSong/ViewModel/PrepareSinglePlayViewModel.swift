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
    
    private var level: String
    private var gameId: String
    private var levelNetworkManager: FullLevelOperation?
    private var musicsPath: [Int:URL]
    private var group: DispatchGroup
    
    init(level currentLevel: String, idGame gameId: String) {
        self.level = currentLevel
        self.gameId = gameId
        self.musicsPath = [:]
        print("the id is \(level)")
        self.group = DispatchGroup()
    }
    
    func prepareDataForStartGame(completion: (()->())?, errorHandle: ((String)->())?) {
        
        loadingLevel(completion: { [weak self] (levelInfo) in
            let listOfSongs = levelInfo.songs
            self?.downloadMusic(musics: listOfSongs, completion: {
                completion?()
            }, errorHandle: { (errorMessage) in
                print("error of loading or downloading songs")
            })
        }) { (error) in
            print("error loading info about level")
        }
        
        
    }
    
    func goToPlaySinglePlay() -> SinglePlayModelType {
        
        let sortedSongs = musicsPath.sorted(by: {$0.key<$1.key})
        let songs = sortedSongs.map({$0.value})
        return SinglePlayViewModel(path: songs, id: gameId)
    }
    
//    func getDestinationUrl(completionUrl: @escaping ([URL?])->() )  {
//        let tasks = [Task(idTask: 1, infoTask: "http://freetone.org/ring/stan/iPhone_5-Alarm.mp3"),
//                     Task(idTask: 2, infoTask: "https://s3.amazonaws.com/kargopolov/kukushka.mp3"),
//                     Task(idTask: 3, infoTask: "https://freetone.org/files/7/wawes_sound.mp3"),
//                     Task(idTask: 4, infoTask: "https://freetone.org/ring/kids/bal.mp3"),]
//
//        downloadMusic(musicUrls: tasks, completion: { [weak self] (value) in
//            print(value)
//            guard let values = self?.musicsPath.map({$0.value}) else {
//                print("there are not map")
//                return
//            }
//            completionUrl(values)
//        }) { (error) in
//            print(error)
//        }
//    }
    
    func loadingLevel(completion: ((LevelResponse)->())?, errorHandle: ((String)->())?) {
        levelNetworkManager = FullLevelOperation(levelId: String(describing: level))
        levelNetworkManager?.start()
        levelNetworkManager?.success = { (levelInfo) in
            print("the result is ok \(levelInfo.name)")
            completion?(levelInfo)
        }
        
        levelNetworkManager?.failure = { (error) in
            print("error of loading indfo about level \(error)")
            errorHandle?(error.localizedDescription)
        }
    }
    
    func downloadSong(taskInfo: SongResponse, songUrl: URL, destination destinationURL: URL, errorHandler: ((Error?)->())?) {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let fileURL = destinationURL
            return (fileURL, [.createIntermediateDirectories])
        }
        
        Alamofire.download(songUrl, to: destination).response { [unowned self] response in
            print(response)
            
            if response.error == nil, let responseMusicPath = response.destinationURL {
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: responseMusicPath, to: destinationURL)
                    if taskInfo.getSongURL() == destinationURL.absoluteString {
                        self.musicsPath[taskInfo.idUrl] = destinationURL
                    }
                    print("File moved to documents folder")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else {
                errorHandler?(response.error)
            }
        }
    }
   
    
    func downloadMusic(musics: [SongResponse], completion: (()->())?, errorHandle: ((String?)->())?) {
        
        for task in musics {
            // create document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let stringMusicUrl = task.getSongURL()
            guard let url = URL(string: stringMusicUrl) else { return }
            // create destination file url
            let destinationUrl =  documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
            
            print(destinationUrl)
            DispatchQueue.global(qos: .userInitiated).async(group: group) { [weak self] in
            // to check if it exists before downloading it
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    print("The file already exists at path")
                    self?.musicsPath[task.idUrl] = destinationUrl
                } else {
                    self?.downloadSong(taskInfo: task, songUrl: url, destination: destinationUrl) { (error) in
                        errorHandle?(error?.localizedDescription)
                    }
                }
            }
        }
        
        group.notify(queue: .main) { [unowned self] in
            if musics.count == self.musicsPath.count {
                completion?()
            } else {
                print("Something went WRONG!!!!!!!!!!!!")
            }
        }

    }
    
}
