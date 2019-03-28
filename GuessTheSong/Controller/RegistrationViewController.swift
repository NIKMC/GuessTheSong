//
//  RegistrationViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import ProgressHUD


class RegistrationViewController: UIViewController {

    @IBOutlet weak var repasswordView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var emailView: UITextField!
    @IBOutlet weak var loginView: UITextField!
    
    @IBOutlet weak var GSButtonOk: UIGSButton!
    //MARK: Keyboard appear/dissapear
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    var activeField: UITextField?
    var keyboardHeight: CGFloat!
    var lastOffset: CGPoint!
    
    private let goToSignIn = "registrationSucceed"
    
    var viewModel: SignUpModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        emailView.delegate = self
        passwordView.delegate = self
        repasswordView.delegate = self
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(self.back(sender:)))
        defaultInit()
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func defaultInit() {
        
        GSButtonOk.style = .normal
        GSButtonOk.text = viewModel?.buttonTextOk()
        
        
        
        GSButtonOk.handler = { [unowned self] (button) in
            ProgressHUD.show()
            if (self.emailView.text! != "" && self.loginView.text! != "" && self.passwordView.text! != "" && self.repasswordView.text! != "") {
                self.viewModel?.checkEmail(email: self.emailView.text!, completion: {
                    if self.passwordView.text! == self.repasswordView.text! {
                        self.viewModel?.checkPasswordOnStrong(password: self.passwordView.text! , handlerSuccess: { [weak self] () in
                            self?.viewModel?.setData(email: (self?.emailView.text!)!, login: (self?.loginView.text!)!, password: (self?.passwordView.text!)!, passwordRep: (self?.repasswordView.text!)!)
                            self?.viewModel?.signUp(completion: { [weak self] (user) in
                                print("ok signUp")
                                OperationQueue.main.addOperation {
                                    ProgressHUD.dismiss()
                                    Session.shared.username = self?.viewModel?.getLogin()
                                    Session.shared.password = self?.viewModel?.getPassword()
                                    self?.performSegue(withIdentifier: (self?.goToSignIn)!, sender: self)
                                }
                                }, errorHandle: { (error) in
                                    print(error)
                                    //            ProgressHUD.dismiss()
                                    OperationQueue.main.addOperation {
                                        ProgressHUD.showError("Login or email already exist!")
                                    }
                            })
                            }, handlerFailure: { (badMessage) in
                                ProgressHUD.showError(badMessage)
    
                        })
                    } else {
                        ProgressHUD.showError("The password and repeat password should be same!")
                    }
                }, failure: { (message) in
                    ProgressHUD.showError(message)
                })
            } else {
                ProgressHUD.showError("All fieds should be not empty!")
            }
            
           
        }
        
    }
    
    func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }

    @objc func back(sender: AnyObject) {
        guard(navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No view controllers to pop off")
                return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func goToLoginTapped(_ sender: UIButton) {
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
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant = self.keyboardHeight
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
