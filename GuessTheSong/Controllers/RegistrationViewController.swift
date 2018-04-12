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
//        socket = Socket_API(connection: .Guest)
//        socket?.delegate = self
//        socket?.connect()
//        socket?.registerResponseEvent()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.back(sender:)))
        Socket_API.sharedInstance.delegate = self
//        Socket_API.SocketAPI.connect(connection: .Guest)
        Socket_API.sharedInstance.registerResponseEvent()
        
    }

    @objc func back(sender: AnyObject) {
        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.REGISTER)
        guard(navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No view controllers to pop off")
                return
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        ProgressHUD.show()
//        socket?.registerEvent(login: loginView.text!, email: emailView.text!, password: passwordView.text!, password2: repasswordView.text!)
        Socket_API.sharedInstance.registerEvent(login: loginView.text!, email: emailView.text!, password: passwordView.text!, password2: repasswordView.text!)
    }
    
    
    @IBAction func goToLoginTapped(_ sender: UIButton) {
//        socket?.disconnect()
//        Socket_API.sharedInstance.disconnect()
        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.REGISTER)
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
        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.REGISTER)
//        socket?.disconnect()
//        Socket_API.SocketAPI.disconnect()
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
