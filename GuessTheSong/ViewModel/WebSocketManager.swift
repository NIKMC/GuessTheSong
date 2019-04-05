//
//  WebSocketManager.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 17/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import Starscream

class WebSocketManager: WebSocketDelegate {
    
    var socket: WebSocket!
    weak var observer: SocketBehaviourDelegate?
    private var ready = false
    init(url urlString: String, token: String, delegate: SocketBehaviourDelegate) {
        observer = delegate
        let url = URL(string: urlString)!
        var webSocketURL: String
        if urlString.contains("ws://terra.co.il/") {
           let webSocketURLString = url.absoluteString.replacingOccurrences(of: "ws://terra.co.il/", with: "ws://terra.co.il:41000/")
            webSocketURL = "\(webSocketURLString)?token=\(token)"
        } else {
            webSocketURL = "\(urlString)?token=\(token)"
        }
        print("The websocket URLString is \(webSocketURL)")
        var request = URLRequest(url: URL(string: webSocketURL)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func setObserver(selfObserver: MultiPlaySocketBehaviourDelegate) {
        observer = selfObserver
    }
    
    func deinitObserver() {
        observer = nil
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
        observer?.socketIsConnected()
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("got some text: \(text)")
        let jsonString = text.data(using: .utf8)!
        do {
            let data = try JSONDecoder().decode(SocketMessage.self, from: jsonString)
            parseMessageFromSocket(response: data)
            print("The websocketDidReceiveMessage message is: \(String(describing: data.message))")
            print("The websocketDidReceiveMessage action is: \(String(describing: data.action))")
            print("The websocketDidReceiveMessage additional is: \(String(describing: data.additional))")
            print("The websocketDidReceiveMessage user id is: \(String(describing: data.id))")
        } catch let error {
            print("Error of parsing \(error)")
        }
    }
    
    func parseMessageFromSocket(response: SocketMessage) {
        
        if let observer = observer as? MultiPlaySocketBehaviourDelegate {
            if let id = response.id, response.action == "intermediate_score", let additional = response.additional {
                observer.scoreOfPlayerWasUpdated(score: Int(additional), userId: id)
            } else if let id = response.id, response.action == "fail" {
                observer.finishedGameFailure(userId: id)
            } else if let id = response.id, response.action == "success", let additional = response.additional {
                //FIXME: - error of parsing response.additional because we have int but we need to double
                observer.finishedGameSuccessfully(userId: id, experience: Double(additional))
            }
        } else {
            if let action = response.action, let message = response.message {
                if action == "starting_game" && message == "All players ready... Starting game..." {
                    ready = true
                    print("All players ready... Starting game...")
                    observer?.startingGame()
                } else if action == "starting_game" && !ready && message == "Starting game..." {
                    ready = true
                    print("Starting game...")
                    observer?.startingGame()
                } else if let id = response.id, action == "downloaded" {
                    let username = message.components(separatedBy: " ")[1]
                    print("The result of ready user in socket response - username: \(username) id: \(id)")
                    observer?.updateReadyUsers(userId: id, name: username)
                }
            }
        }
        
        
        
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }
    
    
    func sendMessage(action: String, score: Int?) {
        let message = SocketMessageSending(action: action, score: score)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(message)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            socket.write(string: jsonString!)
        }
        catch {
        }
    }
    
    func downloadedMusic() {
        let message = SocketMessageSending(action: "downloaded", score: nil)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(message)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            socket.write(string: jsonString!)
        }
        catch {
            print("error send message 'downloaded' to server using socket")
        }
    }
    
    func updatedScore(score: Int) {
        let message = SocketMessageSending(action: "intermediate_score", score: score)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(message)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            socket.write(string: jsonString!)
        }
        catch {
            print("error send message 'intermediate_score' with score \(score) to server using socket")
        }
    }
    
    func finishGameSuccess() {
        let message = SocketMessageSending(action: "success", score: nil)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(message)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            socket.write(string: jsonString!)
        }
        catch {
            print("error send message 'success' to server using socket")
        }
    }
    
    func failGame() {
        let message = SocketMessageSending(action: "fail", score: nil)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(message)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            socket.write(string: jsonString!)
        }
        catch {
            print("error send message 'fail' to server using socket")
        }
    }
}

class SocketMessage: Codable {
    var message: String?
    var action: String?
    var additional: Double?
    var id: Int?
    
    init(message: String?, action: String?, additional: Double?, id: Int?) {
        self.message = message
        self.action = action
        self.additional = additional
        self.id = id
        
    }
}
class SocketMessageSending: Codable {
    
    var action: String?
    var score: Int?
    
    init(action: String?, score: Int?) {
        self.action = action
        self.score = score
    }
}
