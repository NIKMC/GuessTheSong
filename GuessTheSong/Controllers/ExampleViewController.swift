//
//  ExampleViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import ProgressHUD
import SocketIO
import SwiftyJSON

class ExampleViewController: UIViewController {

    
    let defaults = UserDefaults.standard
    
    var delegate: ResponseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Socket_API.sharedInstance.delegate = self
        Socket_API.sharedInstance.connect(connection: .User)
        Socket_API.sharedInstance.profileResponseEvent()
//        ProgressHUD.showSuccess()
        
        
        if let login = defaults.value(forKey: "token") as? String {
            print( "The token is \(login)")
        } else {
            print("Not the Login")
        }
    }

    
    @IBAction func singleTapped(_ sender: UIButton) {
    }
    
    @IBAction func multiTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func profileInfo(_ sender: UIButton) {
//       getProfileEvent(userId: "5ac7c93aa426d060217d8caf")
        Socket_API.sharedInstance.getProfileEvent(userId: "5ac7c93aa426d060217d8caf")
    }
    
}

extension ExampleViewController: ResponseProfileDelegate {
    func success() {
        print("success")
    }
    
    func informErrorMessage(error: String) {
        print("the error is \(error)")
        ProgressHUD.showError(error)
    }
    
    func informDisconnectedMessage() {
        print("the socket was disconnected")
        ProgressHUD.showError("Check your Internet connection ")
    }
   
    func printErrorMessage(error: String?) {
        print("Login error in delegate")
        if let errorMessage = error {
            print("Error message \(errorMessage)")
        }
    }
    
    
}

