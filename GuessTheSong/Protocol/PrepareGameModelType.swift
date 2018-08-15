//
//  GuessSongGameModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol PrepareGameModelType {
 
    
    func prepareDataForStartGame()
    
    func loadingLevel(completion: ((FullDataLevel)->())?, errorHandle: ((String)->())?)
    
    func downloadMusic(musicUrls: [Task], completion: ((String)->())?, errorHandle: ((String)->())?)
    
    func getDestinationUrl(completionUrl: @escaping ([URL?])->() )  
}
