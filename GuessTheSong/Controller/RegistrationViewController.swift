//
//  RegistrationViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
//import SocketIO
import ProgressHUD


class RegistrationViewController: UIViewController {

    @IBOutlet weak var repasswordView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var emailView: UITextField!
    @IBOutlet weak var loginView: UITextField!
    
    
    //MARK: Keyboard appear/dissapear
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    var activeField: UITextField?
    var keyboardHeight: CGFloat!
    var lastOffset: CGPoint!
    
    private let goToSignIn = "registrationSucceed"
    
    var viewModel: SignUpModelType?
    
    override func awakeFromNib() {
//        Socket_API.sharedInstance.changeTypeConnection(toConnection: .Guest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        emailView.delegate = self
        passwordView.delegate = self
        repasswordView.delegate = self
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.back(sender:)))
//        Socket_API.sharedInstance.delegate = self
//        Socket_API.sharedInstance.registerResponseEvent()
        
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }

    @objc func back(sender: AnyObject) {
//        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.REGISTER)
        guard(navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No view controllers to pop off")
                return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        ProgressHUD.show()
        viewModel?.setData(email: emailView.text!, login: loginView.text!, password: passwordView.text!, passwordRep: repasswordView.text!)
        viewModel?.signUp(completion: { [weak self] (user) in
            print("ok signUp")
            ProgressHUD.dismiss()
            OperationQueue.main.addOperation {
                self?.performSegue(withIdentifier: (self?.goToSignIn)!, sender: self)
            }
        }, errorHandle: { (error) in
            print(error)
//            ProgressHUD.dismiss()
            ProgressHUD.showError(error)
        })
//        Socket_API.sharedInstance.registerEvent(login: loginView.text!, email: emailView.text!, password: passwordView.text!, password2: repasswordView.text!)
    }
    
    
    @IBAction func goToLoginTapped(_ sender: UIButton) {
//        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.REGISTER)
        self.performSegue(withIdentifier: self.goToSignIn, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == goToSignIn {
            if let dvc = segue.destination as? LoginViewController {
                dvc.viewModel = viewModel?.signIn()
            }
        } 
        
    }
    
}


// MARK: UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
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

extension RegistrationViewController {
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



//extension RegistrationViewController: ResponseRegisterDelegate {
//    func informErrorMessage(error: String) {
//        print("the error is \(error)")
//        ProgressHUD.showError(error)
//    }
//    
//    func informDisconnectedMessage() {
//        print("the socket was disconnected")
//        ProgressHUD.showError("Disconneted connection")
//    }
//    
//    
//    
//    func registerSuccess() {
//        print("register success in delegate")
//        ProgressHUD.dismiss()
//        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.REGISTER)
//        self.performSegue(withIdentifier: "registrationSucceed", sender: self)
//    }
//    
//    func printErrorMessage(error: String?) {
//        print("register error in delegate")
//        ProgressHUD.showError()
//        if let errorMessage = error {
//            print("Error message \(errorMessage)")
//        }
//    }
//}
