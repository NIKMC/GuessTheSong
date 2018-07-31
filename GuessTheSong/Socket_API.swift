////
////  API.swift
////  GuessTheSong
////
////  Created by Ivan Nikitin on 30/03/2018.
////  Copyright © 2018 Иван Никитин. All rights reserved.
////
//
////import SocketIO
//import SwiftyJSON
//import UIKit
//
//protocol ResponseRegisterDelegate: ResponseDelegate {
//    func registerSuccess()
//}
//protocol ResponseLoginDelegate: ResponseDelegate {
//    func loginSuccess(token: String?)
//}
//
//protocol ResponseProfileDelegate: ResponseDelegate {
//    func success()
//}
//
//protocol ResponseGameDelegate: ResponseDelegate {
//    func success()
//    func createGameResult(roomId: String)
//    func downloadSongsResult()
//    func readyToGameResult(result: String)
//    func startGame(action: String)
//}
//
//protocol ResponseDelegate {
//    func printErrorMessage(error: String?)
//    func informDisconnectedMessage()
//    func informErrorMessage(error: String)
//}
//
//enum TypeConnection: String {
//    case Guest = "guest"
//    case User = "users"
//}
//
//enum EventName: String {
//    case LOGIN = "login-response"
//    case REGISTER = "register-response"
//    case PROFILE = "profile-response"
//    case CREATE_GAME = "creategame-response"
//    case DOWNLOAD_SONGS = "downloadsongs-response"
//    case READY_GAME = "readytogame-response"
//    case START_GAME = "startgame"
//}
//
//class Socket_API {
//
//    open static let sharedInstance = Socket_API()
//    private var socket: SocketIOClient?
//    private let api = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String
//    var delegate: ResponseDelegate?
//    private var manager: SocketManager?
//     init() {    }
//
//
//
//    //MARK: Set up connection function
//
//    func connect(connection: TypeConnection){
//        switch connection {
//        case .User:
//            manager = SocketManager(socketURL: URL(string: api!)!)
//            if let token = UserDefaults.standard.value(forKey: "token") as? String {
//                print("connection for User")
//                manager?.setConfigs([.connectParams(["token" : token]),
//                                     .log(true),
//                                     .forcePolling(true),
//                                     .reconnects(true),
//                                     .reconnectWait(3),
//                                     .reconnectAttempts(50),
//                                     .compress])
//            socket = manager?.socket(forNamespace: "/\(connection.rawValue)")
//            } else {
//                manager?.setConfigs([.log(true),
//                                     .forcePolling(true),
//                                     .reconnects(true),
//                                     .reconnectWait(3),
//                                     .reconnectAttempts(50),
//                                     .compress])
//                socket = manager?.socket(forNamespace: "/\(TypeConnection.Guest.rawValue)")
//            }
//        case .Guest:
//            print("connection for Guest")
//            manager = SocketManager(socketURL: URL(string: api!)!)
//            manager?.setConfigs([.log(true),
//                                .forcePolling(true),
//                                .reconnects(true),
//                                .reconnectWait(5),
//                                .reconnectAttempts(50),
//                                .compress])
//            socket = manager?.socket(forNamespace: "/\(connection.rawValue)")
//        }
//        socket?.connect()
//        socket?.on(clientEvent: .error) { data,error  in
//            print("data in socket error \(data[0])")
//            print("socket error")
//            self.delegate?.informErrorMessage(error: data[0] as! String)
//            print("data is \(error)")
//        }
//        socket?.on(clientEvent: .connect) { data,error  in
//            print("data in socket connected \(data[0])")
//            print("socket connected")
//            print("data is \(error)")
//        }
//
//        socket?.on(clientEvent: .disconnect) { data,error  in
//            print("data in socket disconnected \(data[0])")
//            print("socket disconnected")
////            self.delegate?.informDisconnectedMessage()
//            print("data is \(error)")
//        }
//    }
//
//    func changeTypeConnection(toConnection: TypeConnection){
//        socket?.disconnect()
//        print("changeTypeConnection")
//        connect(connection: toConnection)
//    }
//
//    func disconnect() {
////        manager.disconnect()
//        socket?.disconnect()
//    }
//
//    func resetResponseEvent(eventName: EventName) {
//        socket?.off(eventName.rawValue)
//    }
//
//    //MARK: Register request and response
//
//    func registerEvent(login loginText: String, email emailText: String, password passwordText: String, password2 password2Text: String) {
//        socket?.emit("register", RegisterRequest(username: loginText, email: emailText, password: passwordText, password2: password2Text))
//
//    }
//
//    func registerResponseEvent() {
//        socket?.on(EventName.REGISTER.rawValue) { response, ack in
//            let swiftyJson = JSON((response[0] as! [String : AnyObject]))
//            do {
//                let data = try swiftyJson.rawData()
//                let event = try JSONDecoder().decode(ResponseMessage.self, from: data)
//                if !event.err {
//                    print("converted error is \(event.err)")
//                    (self.delegate as? ResponseRegisterDelegate)?.registerSuccess()
//                } else {
//                    print("converted error is \(event.err)")
////                    self.delegate?.registerError(error: event.msg)
//                    (self.delegate as? ResponseRegisterDelegate)?.printErrorMessage(error: event.msg)
//                }
//            } catch let myJSONError {
//                print(myJSONError)
//            }
//        }
//    }
//
//    //MARK: getProfile request and response
//
//    func getProfileEvent(userId: String) {
//        socket?.emit("profile", ProfileRequest(id: userId))
//    }
//
//    func profileResponseEvent() {
//        socket?.on(EventName.PROFILE.rawValue) { response, ack in
//            print("The profile-response is \(response)")
//            let swiftyJson = JSON((response[0] as! [String : AnyObject]))
//            do {
//                let data = try swiftyJson.rawData()
//                let event = try JSONDecoder().decode(ResponseMessage.self, from: data)
//                if !event.err {
//                    print("converted error is \(event.err)")
//                    (self.delegate as? ResponseProfileDelegate)?.success()
//                } else {
//                    print("converted error is \(event.err)")
//                    (self.delegate as? ResponseProfileDelegate)?.printErrorMessage(error: event.msg)
//                }
//            } catch let myJSONError {
//                print(myJSONError)
//            }
//
//        }
//    }
//
//    //MARK: Login request and response
//
//    func loginEvent(email emailText: String, password passwordText: String) {
//        socket?.emit("login", LoginRequest(email: emailText, password: passwordText))
//    }
//
//    func loginResponseEvent() {
//        socket?.on(EventName.LOGIN.rawValue) { response, ack in
//            print("The login-response is \(response)")
//            let swiftyJson = JSON((response[0] as! [String : AnyObject]))
//            do {
//                let data = try swiftyJson.rawData()
//                let event = try JSONDecoder().decode(ResponseMessage.self, from: data)
//                if !event.err {
//                    print("converted error is \(event.err)")
//                    (self.delegate as? ResponseLoginDelegate)?.loginSuccess(token: event.token)
//                } else {
//                    print("converted error is \(event.err)")
//                    (self.delegate as? ResponseLoginDelegate)?.printErrorMessage(error: event.msg)
//                }
//            } catch let myJSONError {
//                print(myJSONError)
//            }
//
//        }
//    }
//
//    //MARK: CreateGame request and response
//
//    func createGameEvent(id levelId: String) {
//        socket?.emit("creategame", GameRequest(id: levelId))
//    }
//
//    func createGameResponseEvent() {
//        socket?.on(EventName.CREATE_GAME.rawValue) { response, ack in
//            print("The create-game- response is \(response)")
//            let swiftyJson = JSON((response[0] as! [String: AnyObject]))
//            do {
//                let data = try swiftyJson.rawData()
//                let event = try JSONDecoder().decode(ResponseCreateGameMessage.self, from: data)
////                if !event.err {
////                    print("converted error is \(event.err)")
//                    (self.delegate as? ResponseGameDelegate)?.createGameResult(roomId: event.room)
////                } else {
////                    print("converted error is \(event.err)")
////                    (self.delegate as? ResponseGameDelegate)?.printErrorMessage(error: event.msg)
////                }
//            } catch let myJSONError {
//                print(myJSONError)
//            }
//        }
//    }
//
//    //MARK: DownloadMusic request and response
//
//    func downloadSongsEvent(roomId: String) {
//        socket?.emit("downloadsongs", RoomRequest(room: roomId))
//    }
//
//    func downloadSongsResponseEvent() {
//        socket?.on(EventName.DOWNLOAD_SONGS.rawValue) { response, ack in
//        print("The DOWNLOAD_SONGS response is \(response)")
//            let swiftyJson = JSON((response[0] as! [String: AnyObject]))
//            do {
//                let data = try swiftyJson.rawData()
//                let event = try JSONDecoder().decode(ResponseDownloadSongs.self, from: data)
//                if !event.err {
//                    print("converted error is \(event.err)")
//                    (self.delegate as? ResponseGameDelegate)?.downloadSongsResult()
//                } else {
//                    print("converted error is \(event.err)")
//                    (self.delegate as? ResponseGameDelegate)?.printErrorMessage(error: event.msg)
//                }
//            } catch let myJSONError {
//                print(myJSONError)
//            }
//        }
//    }
//
//    //MARK: Ready to Game request and response
//
//    func readyToGameEvent(roomId: String) {
//         socket?.emit("readytogame", RoomRequest(room: roomId))
//    }
//
//    func readyToGameResponseEvent() {
//        socket?.on(EventName.READY_GAME.rawValue) { response, ack in
//            print("The ready-game- response is \(response)")
//            let swiftyJson = JSON((response[0] as! [String: AnyObject]))
//            do {
//                let data = try swiftyJson.rawData()
//                let event = try JSONDecoder().decode(ResponseReadyGameMessage.self, from: data)
//                if !event.err {
//                    print("converted error is \(event.err)")
//                    (self.delegate as? ResponseGameDelegate)?.readyToGameResult(result: event.msg)
//                } else {
//                    print("converted error is \(event.err)")
//                    (self.delegate as? ResponseGameDelegate)?.printErrorMessage(error: event.msg)
//                }
//            } catch let myJSONError {
//                print(myJSONError)
//            }
//        }
//    }
//
//    //MARK: Start game response
//
//    func startGameResponseEvent() {
//        socket?.on(EventName.START_GAME.rawValue) { response, ack in
//            print("The start-game- response is \(response)")
//            let swiftyJson = JSON((response[0] as! [String: AnyObject]))
//            do {
//                let data = try swiftyJson.rawData()
//                let event = try JSONDecoder().decode(ResponseStartGameMessage.self, from: data)
////                if !event.err {
////                    print("converted error is \(event.err)")
//                (self.delegate as? ResponseGameDelegate)?.startGame(action: event.action)
////                } else {
////                    print("converted error is \(event.err)")
////                    (self.delegate as? ResponseGameDelegate)?.printErrorMessage(error: event.action)
////                }
//            } catch let myJSONError {
//                print(myJSONError)
//            }
//        }
//    }
//
//
//}
