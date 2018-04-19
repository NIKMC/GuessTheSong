//
//  API.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 30/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import SocketIO
import SwiftyJSON
import UIKit

protocol ResponseRegisterDelegate: ResponseDelegate {
    func registerSuccess()
}
protocol ResponseLoginDelegate: ResponseDelegate {
    func loginSuccess(token: String?)
}

protocol ResponseProfileDelegate: ResponseDelegate {
    func success()
}
protocol ResponseDelegate {
    func printErrorMessage(error: String?)
    func informDisconnectedMessage()
    func informErrorMessage(error: String)
}

enum TypeConnection: String {
    case Guest = "guest"
    case User = "users"
}

enum EventName: String {
    case LOGIN = "login-response"
    case REGISTER = "register-response"
}

class Socket_API {
    
    open static let sharedInstance = Socket_API()
    private var socket: SocketIOClient?
    private let api = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String
    var delegate: ResponseDelegate?
    private var manager: SocketManager?
     init() {    }
   
    
    //    private lazy var manager = SocketManager(socketURL: URL(string: api!)!, config: [.log(true), .reconnects(true), .reconnectWait(5), .reconnectAttempts(50), .compress])
    
    
    //        manager = SocketManager(socketURL: URL(string: api!)!, config: [.log(true), .reconnects(true), .reconnectWait(5), .reconnectAttempts(50), .compress])
    //
    
    

//    init(connection: TypeConnection) {
////        manager = SocketManager(socketURL: URL(string: api!)!, config: [.log(true), .reconnects(true), .reconnectWait(5), .reconnectAttempts(50), .compress])
//       socket = manager.socket(forNamespace: "/\(connection.rawValue)")
//    }
    
    func connect(connection: TypeConnection){
        switch connection {
        case .User:
            if let token = UserDefaults.standard.value(forKey: "token") as? String {
                print("connection for User")
                manager = SocketManager(socketURL: URL(string: api!)!)
                manager?.setConfigs([.connectParams(["token" : token]),
                                    .log(true),
                                    .forcePolling(true),
                                    .reconnects(true),
                                    .reconnectWait(3),
                                    .reconnectAttempts(50),
                                    .compress])
                
                socket = manager?.socket(forNamespace: "/\(connection.rawValue)")
                }
        case .Guest:
            print("connection for Guest")
            manager = SocketManager(socketURL: URL(string: api!)!)
            manager?.setConfigs([.log(true),
                                .forcePolling(true),
                                .reconnects(true),
                                .reconnectWait(5),
                                .reconnectAttempts(50),
                                .compress])
            socket = manager?.socket(forNamespace: "/\(connection.rawValue)")
        }
        socket?.connect()
        socket?.on(clientEvent: .error) { data,error  in
            print("data in socket error \(data[0])")
            print("socket error")
            self.delegate?.informErrorMessage(error: data[0] as! String)
            print("data is \(error)")
        }
        socket?.on(clientEvent: .connect) { data,error  in
            print("data in socket connected \(data[0])")
            print("socket connected")
            print("data is \(error)")
        }
        
        socket?.on(clientEvent: .disconnect) { data,error  in
            print("data in socket disconnected \(data[0])")
            print("socket disconnected")
            self.delegate?.informDisconnectedMessage()
            print("data is \(error)")
        }
    }
    
    func disconnect() {
//        manager.disconnect()
        socket?.disconnect()
        
    }
    
    func registerEvent(login loginText: String, email emailText: String, password passwordText: String, password2 password2Text: String) {
        socket?.emit("register", RegisterRequest(username: loginText, email: emailText, password: passwordText, password2: password2Text))
        
    }
    
    func resetResponseEvent(eventName: EventName) {
        socket?.off(eventName.rawValue)
    }
    
    func registerResponseEvent() {
        socket?.on("register-response") { response, ack in
            let swiftyJson = JSON((response[0] as! [String : AnyObject]))
            do {
                let data = try swiftyJson.rawData()
                let event = try JSONDecoder().decode(ResponseMessage.self, from: data)
                if !event.err {
                    print("converted error is \(event.err)")
                    (self.delegate as? ResponseRegisterDelegate)?.registerSuccess()
                } else {
                    print("converted error is \(event.err)")
//                    self.delegate?.registerError(error: event.msg)
                    (self.delegate as? ResponseRegisterDelegate)?.printErrorMessage(error: event.msg)
                }
            } catch let myJSONError {
                print(myJSONError)
            }
        }
    }
    
    func loginEvent(email emailText: String, password passwordText: String) {
        socket?.emit("login", LoginRequest(email: emailText, password: passwordText))
    }
    
    func getProfileEvent(userId: String) {
        socket?.emit("profile", ProfileRequest(id: userId))
    }
    
    func profileResponseEvent() {
        socket?.on("profile-response") { response, ack in
            print("The profile-response is \(response)")
            let swiftyJson = JSON((response[0] as! [String : AnyObject]))
            do {
                let data = try swiftyJson.rawData()
                let event = try JSONDecoder().decode(ResponseMessage.self, from: data)
                if !event.err {
                    print("converted error is \(event.err)")
                    (self.delegate as? ResponseProfileDelegate)?.success()
                } else {
                    print("converted error is \(event.err)")
                    (self.delegate as? ResponseProfileDelegate)?.printErrorMessage(error: event.msg)
                }
            } catch let myJSONError {
                print(myJSONError)
            }
            
        }
    }
    
    func loginResponseEvent() {
        socket?.on("login-response") { response, ack in
            print("The login-response is \(response)")
            let swiftyJson = JSON((response[0] as! [String : AnyObject]))
            do {
                let data = try swiftyJson.rawData()
                let event = try JSONDecoder().decode(ResponseMessage.self, from: data)
                if !event.err {
                    print("converted error is \(event.err)")
                   (self.delegate as? ResponseLoginDelegate)?.loginSuccess(token: event.token)
                } else {
                    print("converted error is \(event.err)")
                    (self.delegate as? ResponseLoginDelegate)?.printErrorMessage(error: event.msg)
                }
            } catch let myJSONError {
                print(myJSONError)
            }
            
        }
    }
}
