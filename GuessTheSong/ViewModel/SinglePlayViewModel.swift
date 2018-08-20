//
//  SinglePlayViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class SinglePlayViewModel: SinglePlayModelType {
    
    private var levelOfLive: Int
    private var pathOfSongs: [URL]
    private var index: Int
    private var gameId: String
    
    func decreaseLive() -> Bool {
        self.levelOfLive = currentLive() - 1
        return (self.levelOfLive) == 0 ? true : false
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
        nextSong()
        return destination
    }
    
    func nextSong() {
        self.index = currentIndex() + 1
    }
    
    init(path: [URL], id gameId: String) {
        self.index = 0
        self.levelOfLive = 3
        self.pathOfSongs = path
        self.gameId = gameId
    }
}
