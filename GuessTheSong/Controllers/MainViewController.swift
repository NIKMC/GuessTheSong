//
//  ViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import ProgressHUD

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        Socket_API.sharedInstance.delegate = self
        Socket_API.sharedInstance.connect(connection: .Guest)
        
        // Do any additional setup after loading the view, typically from a nib.
    }



}
extension MainViewController: ResponseDelegate {
    func printErrorMessage(error: String?) {
        print("Login error in delegate")
        ProgressHUD.showError()
        if let errorMessage = error {
            print("Error message \(errorMessage)")
        }
    }
    
    func informErrorMessage(error: String) {
        print("the error is \(error)")
        ProgressHUD.showError(error)
    }
    
    func informDisconnectedMessage() {
        print("the socket was disconnected")
        ProgressHUD.showError("Check your Internet connection ")
        
    }
    
    
}

