//
//  RegistrationViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import SocketIO
import Starscream
import SwiftyJSON


class RegistrationViewController: UIViewController {

    @IBOutlet weak var repasswordView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var emailView: UITextField!
    @IBOutlet weak var loginView: UITextField!
    
    let manager = SocketManager(socketURL: URL(string: "http://85.143.211.98:50340")!, config: [.log(true), .compress])
    
    lazy var socket = manager.defaultSocket
//    var socket = Socket_API().getSocket().connect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.connect()
        socket.on("register-response") { response, ack in
            print("The value is \(response)")
            
            let swiftyJson = JSON((response[0] as! [String : AnyObject]))
           
            do {
                let data = try swiftyJson.rawData()
                let event = try JSONDecoder().decode(ResponseMessage.self, from: data)
                if let message = event.msg {
                    print("converted message is \(message)")
                }
                print("converted error is \(event.err)")
            } catch let myJSONError {
                print(myJSONError)
            }
            
        }
    }

    @IBAction func registerTapped(_ sender: UIButton) {
        

//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//            print("data is \(data)")
//        }
//        
//        socket.on(clientEvent: .error) {data,error  in
//            print("data in socket error \(data[0])")
//            print("socket error")
//            print("data is \(error)")
//        }
        socket.emit("register", RegisterRequest(username: loginView.text!, email: emailView.text!, password: passwordView.text!, password2: repasswordView.text!))
       
    }
    
    
    
}
