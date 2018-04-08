//
//  RegistrationViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import SocketIO
import ProgressHUD


class RegistrationViewController: UIViewController {

    @IBOutlet weak var repasswordView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var emailView: UITextField!
    @IBOutlet weak var loginView: UITextField!
    
    var socket : Socket_API?
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = Socket_API(connection: .Guest)
        socket?.delegate = self
        socket?.connect()
        socket?.registerResponseEvent()
        
    }

    @IBAction func registerTapped(_ sender: UIButton) {
        ProgressHUD.show()
        socket?.registerEvent(login: loginView.text!, email: emailView.text!, password: passwordView.text!, password2: repasswordView.text!)
    }
    
    
    @IBAction func goToLoginTapped(_ sender: UIButton) {
        socket?.disconnect()
//        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "registrationSucceed", sender: self)
    }
}

extension RegistrationViewController: ResponseRegisterDelegate {
    func informErrorMessage(error: String) {
        print("the error is \(error)")
        ProgressHUD.showError(error)
    }
    
    func informDisconnectedMessage() {
        print("the socket was disconnected")
        ProgressHUD.showError("Disconneted connection")
    }
    
    func registerSuccess() {
        print("register success in delegate")
        ProgressHUD.dismiss()
        socket?.disconnect()
        self.performSegue(withIdentifier: "registrationSucceed", sender: self)
    }
    
    func printErrorMessage(error: String?) {
        print("register error in delegate")
        ProgressHUD.showError()
        if let errorMessage = error {
            print("Error message \(errorMessage)")
        }
    }
}
