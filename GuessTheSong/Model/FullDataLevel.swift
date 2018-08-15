//
//  FullDataLevel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 06/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class FullDataLevel: Codable {
    var listOfLyrics: [Task]
    var listOfCorrectWords: [Answers]
    var listOfUrlSongs: [Task]
    
    init(lyrics: [Task], answers: [Answers], urlSongs: [Task]) {
        self.listOfLyrics = lyrics
        self.listOfCorrectWords = answers
        self.listOfUrlSongs = urlSongs
    }
}

struct Answers: Codable {
    var idQuestion: Int
    var answers: [String]
}

struct Task: Codable {
    var idTask: Int
    var infoTask: String
}
