//
//  LoginViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var loginView: UITextField!
   
    let defaults = UserDefaults.standard
    
    let manager = SocketManager(socketURL: URL(string: "http://85.143.211.98:50340")!, config: [.log(true), .compress])
    lazy var socket = manager.defaultSocket
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        socket.disconnect()
        socket.connect()
        socket.on("login-response") { response, ack in
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
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            print("data is \(data)")
        }

        socket.on(clientEvent: .error) {data,error  in
            print("data in socket error \(data[0])")
            print("socket error")
            print("data is \(error)")
        }
        
    }

//    @IBAction func LoginPressed(_ sender: UIButton) {
//        defaults.setValue("QwertyLogin", forKey: "loginKey")
//
//    }
    
    @IBAction func okPressed(_ sender: UIButton) {
        socket.emit("login", LoginRequest(username: loginView.text!, password: passwordView.text!))
        
    }
    
    @IBAction func goToregistration(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    

}
