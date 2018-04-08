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
import ProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var emailView: UITextField!
   
    var user: UserProfile?
    let defaults = UserDefaults.standard
     var socket : Socket_API?
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        socket = Socket_API(connection: .Guest)
        socket?.delegate = self
        socket?.connect()
        socket?.loginResponseEvent()
        if let email = defaults.value(forKey: "user_email") as? String {
            emailView.text = email
        }
        if let password = defaults.value(forKey: "user_password") as? String {
            passwordView.text = password
        }
        
        
    }

//    @IBAction func LoginPressed(_ sender: UIButton) {
//        defaults.setValue("QwertyLogin", forKey: "loginKey")
//
//    }
    
    @IBAction func okPressed(_ sender: UIButton) {
        ProgressHUD.show()
        socket?.loginEvent(email: emailView.text!, password: passwordView.text!)
        user = UserProfile(email: emailView.text!, password: passwordView.text!)
    }
    
    @IBAction func goToregistration(_ sender: UIButton) {
        socket?.disconnect()
//        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "hasNotAccount", sender: self)
        
    }
    
    
}
extension LoginViewController: ResponseLoginDelegate {

    func informErrorMessage(error: String) {
        print("the error is \(error)")
        ProgressHUD.showError(error)
    }
    
    func informDisconnectedMessage() {
        print("the socket was disconnected")
        ProgressHUD.showError("Check your Internet connection ")
        
    }
    
    func loginSuccess(token: String?) {
        print("Login success in delegate")
        ProgressHUD.dismiss()
        socket?.disconnect()
        if let currentToken = token {
            defaults.setValue(currentToken, forKey: "token")
            defaults.setValue(user?.email, forKey: "user_email")
            defaults.setValue(user?.password, forKey: "user_password")
        }
//        self.dismiss(animated: true, completion: nil)
//        self.performSegue(withIdentifier: "", sender: self)
    }
    
    func printErrorMessage(error: String?) {
        print("Login error in delegate")
        ProgressHUD.showError()
        if let errorMessage = error {
            print("Error message \(errorMessage)")
        }
    }
}

