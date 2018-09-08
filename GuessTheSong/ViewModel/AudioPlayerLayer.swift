//
//  AudioPlayerLayer.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 29/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerLayer {
    
    let player: AVQueuePlayer!
    private var isPlay = false
    func playMusic() {
        if !isPlay {
            player.play()
            isPlay = true
        } else {
            nextMusic()
        }
    }
    
    private func nextMusic() {
        player.advanceToNextItem()
        isPlay = true
    }
    
    func pausePlay() {
        player.pause()
    }
    
    @objc func itemDidFinishPlaying(_ notification: NSNotification) {
        player.pause()
        isPlay = false
    }
    
    init(urls songs: [URL]) {
        
        let items: [AVPlayerItem] = songs.map { AVPlayerItem(url: $0) }
        player = AVQueuePlayer(items: items)
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}
