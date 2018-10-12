//
//  GuessSongGameModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol PrepareGameModelType {
 
    
    func prepareDataForStartGame(completion: (()->())?, errorHandle: ((String)->())?)
    
    func loadingLevel(completion: ((LevelResponse)->())?, errorHandle: ((String)->())?)
    
    func downloadSong(taskInfo: SongResponse, destination destinationURL: URL, errorHandler: ((Error)->())?)
    
    func downloadMusic(musics: [SongResponse], completion: (()->())?, errorHandle: ((String)->())?)
    
//    func getDestinationUrl(completionUrl: @escaping ([URL?])->() )
    
    func goToPlaySinglePlay() -> GamePlayModelType
}
