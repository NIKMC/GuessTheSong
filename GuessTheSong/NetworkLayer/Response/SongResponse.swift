//
//  SongResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 15/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class SongResponse: Codable {
    
    var idUrl: Int
    var name: String
    var audio_file: String
    var song_text: String
    var missing_words_text: [String]
    
    init(idUrl: Int, name: String, audio_file: String, song_text: String, missing_words_text: [String]) {
        self.idUrl = idUrl
        self.name = name
        self.audio_file = audio_file
        self.song_text = song_text
        self.missing_words_text = missing_words_text
    }
    
    func getNameOfSong() -> String {
        return name
    }
    
    func getSongURL() -> String {
        return audio_file
    }
    
    func getText() -> String {
        return song_text
    }
    
    func getListOfAnswers() -> [String] {
        return missing_words_text
    }
    
    func getIdSongURL() -> Int {
        return idUrl
    }
}
