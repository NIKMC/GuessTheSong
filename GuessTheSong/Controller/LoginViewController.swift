//
//  LoginViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
//import SocketIO
import SwiftyJSON
import ProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var emailView: UITextField!
   
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    private let goToMenu = "goToMainMenuGame"
    private let goToSignUp = "hasNotAccount"
    
    var activeField: UITextField?
    var keyboardHeight: CGFloat!
    var lastOffset: CGPoint!
    
    var user: Profile?
    var viewModel: SignInModelType?

    
    
    override func awakeFromNib() {
//        Socket_API.sharedInstance.changeTypeConnection(toConnection: .Guest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        emailView.delegate = self
        passwordView.delegate = self
        
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.back(sender:)))

//        Socket_API.sharedInstance.delegate = self
//        Socket_API.sharedInstance.loginResponseEvent()
        loadingData()
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    func loadingData() {
        guard let email = viewModel?.loadLogin(), let password = viewModel?.loadPassword() else { return }
        emailView.text = email
        passwordView.text = password
    }
    
    func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    @objc func back(sender: AnyObject) {
//        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.LOGIN)
        guard(navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No view controllers to pop off")
                return
        }
    }

    
    @IBAction func okPressed(_ sender: UIButton) {
        
        
//        ProgressHUD.show()
        viewModel?.setLoginAndPassword(email: emailView.text!, password: passwordView.text!)
//        self.performSegue(withIdentifier: goToMenu, sender: sender)
        viewModel?.signIn(completion: { [weak self] (user) in
            print("sing IN ok")
            ProgressHUD.dismiss()
            self?.performSegue(withIdentifier: (self?.goToMenu)!, sender: sender)
            
        }, errorHandle: { (error) in
            print(error)
            ProgressHUD.showError(error)
        })
        
        
        
//        socket?.loginEvent(email: emailView.text!, password: passwordView.text!)
//        Socket_API.sharedInstance.loginEvent(email: emailView.text!, password: passwordView.text!)
        user = Profile(email: emailView.text!, password: passwordView.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == goToMenu {
            if let dvc = segue.destination as? MenuViewController {
                dvc.viewModel = viewModel?.goToTheMenu()
            }
        } else if identifier == goToSignUp {
            if let dvc = segue.destination as? RegistrationViewController {
                dvc.viewModel = viewModel?.signUp()
            }
        }
        
    }
    
    @IBAction func goToRegistration(_ sender: UIButton) {

//        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.LOGIN)
        self.performSegue(withIdentifier: goToSignUp, sender: self)

    }

    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView?.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}

extension LoginViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
                        print("keyboardwillshow != nil")
            return
        }
                    print("keyboardShow")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant += self.keyboardHeight
            })
            
            // move if keyboard hide input field
            let distanceToBottom = (self.scrollView?.frame.size.height)! - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            
            if collapseSpace < 0 {
                // no collapse
                return
            }
            
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView?.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            guard self.keyboardHeight != nil else {return}
            self.constraintContentHeight.constant -= self.keyboardHeight

            self.scrollView?.contentOffset = self.lastOffset
        }
        keyboardHeight = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}




//extension LoginViewController: ResponseLoginDelegate {
//
//    func informErrorMessage(error: String) {
//        print("the error is \(error)")
//        ProgressHUD.showError(error)
//    }
//
//    func informDisconnectedMessage() {
//        print("the socket was disconnected")
////        ProgressHUD.showError("Check your Internet connection ")
//        ProgressHUD.dismiss()
//        self.performSegue(withIdentifier: "goToMainMenuGame", sender: self)
//    }
//
//    func loginSuccess(token: String?) {
//        print("Login success in delegate")
////        ProgressHUD.dismiss()
//
//        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.LOGIN)
//
//        Socket_API.sharedInstance.changeTypeConnection(toConnection: .User)
//
//        if let currentToken = token {
//            defaults.setValue(currentToken, forKey: "token")
//            defaults.setValue(user?.email, forKey: "user_email")
//            defaults.setValue(user?.password, forKey: "user_password")
//        }
//    }
//    
//    func printErrorMessage(error: String?) {
//        print("Login error in delegate")
//        ProgressHUD.showError()
//        if let errorMessage = error {
//            print("Error message \(errorMessage)")
//        }
//    }
//
//
//}

