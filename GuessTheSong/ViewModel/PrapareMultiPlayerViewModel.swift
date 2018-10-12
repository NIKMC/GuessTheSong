//
//  PrapareMultiPlayerViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 16/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import Alamofire

class PrepareMultiPlayerViewModel {
    
    private var musicsPath: [Int:URL]
    private var group: DispatchGroup
    private var fullMusics: [SongResponse]
    private var websocket: String?
    
    init() {
        self.musicsPath = [:]
        self.fullMusics = []
        self.group = DispatchGroup()
    }
    
    func prepareDataForStartGame(completion: (() -> ())?, errorHandle: ((String) -> ())?) {
        joinToMultiplayer(completion: { [weak self] (multiPlayerResponse) in
            self?.websocket = multiPlayerResponse.websocket_url
            self?.fullMusics.removeAll()
            let listOfSongs = multiPlayerResponse.game.songs
            
            //FIXME: - uncommit this line
//            self?.fullMusics.append(contentsOf: listOfSongs)
            self?.downloadMusic(musics: listOfSongs, completion: {
                completion?()
            }, errorHandle: { (errorMessage) in
                print("error of loading or downloading songs")
                errorHandle?(errorMessage)
            })
        }) { (error) in
            errorHandle?(error)
        }
    }
    
    func joinToMultiplayer(completion: ((MultiPlayerResponse) -> ())?, errorHandle: ((String) -> ())?) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            errorHandle?("Error update token")
            return
        }
        let levelNetworkManager = MultiPlayerJoinOperation(token: token)
        levelNetworkManager.start()
        levelNetworkManager.success = { (multiPlayerResponse) in
            print("the result is ok \(multiPlayerResponse.websocket_url)")
            completion?(multiPlayerResponse)
        }
        
        levelNetworkManager.failure = { (error) in
            print("error of loading indfo about level \(error)")
            errorHandle?(error.localizedDescription)
        }
    }
    
    func downloadSong(taskInfo: SongResponse, destination destinationURL: URL, errorHandler: ((Error) -> ())?) {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let fileURL = destinationURL
            return (fileURL, [.createIntermediateDirectories])
        }
        
        let stringMusicUrl = taskInfo.getSongURL()
        guard let url = URL(string: stringMusicUrl) else { return }
        
        
        Alamofire.download(url, to: destination).response { [unowned self] response in
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
    
    func goToPlaySinglePlay() -> SinglePlayModelType {
        return SinglePlayViewModel(action: .Multy, path: [], id: 1, info: [])
    }
    
    
}
