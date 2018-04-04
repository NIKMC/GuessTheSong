//
//  API.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 30/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import SocketIO
import UIKit

class Socket_API {
    
    let manager = SocketManager(socketURL: URL(string: "http://85.143.211.98:50340")!, config: [.log(true), .compress])
    var socket : SocketIOClient
    
    init(){
        socket = manager.defaultSocket
//        connect()
    }
    
    func connect(){
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    
    func getSocket() -> SocketIOClient{
        return self.socket
    }
}
