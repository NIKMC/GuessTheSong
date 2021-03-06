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
    @IBOutlet weak var GSButtonOk: UIGSButton!
    
    private let goToMenu = "goToMainMenuGame"
    private let goToSignUp = "hasNotAccount"
    private let MenuControllerID = "MenuControllerID"
    
    var activeField: UITextField?
    var keyboardHeight: CGFloat!
    var lastOffset: CGPoint!
    
    var user: Profile?
    var viewModel: SignInModelType?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        emailView.delegate = self
        passwordView.delegate = self
        defaultInit()
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(self.back(sender:)))
        loadingData()
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    func defaultInit() {
        
        GSButtonOk.style = .normal
       
        GSButtonOk.text = viewModel?.buttonTextOk()
        
        
        GSButtonOk.handler = { [unowned self] (button) in
            //FIXME: Doesn't dismiss when error of request
            if (self.emailView.text! != "" && self.passwordView.text! != "" ) {
                ProgressHUD.show()
                self.viewModel?.setLoginAndPassword(email: self.emailView.text!, password: self.passwordView.text!)
                self.viewModel?.signIn(completion: { [unowned self] (user) in
                    print("sing IN ok")
                    OperationQueue.main.addOperation {
                        ProgressHUD.dismiss()
                        self.performSegue(withIdentifier: self.goToMenu, sender: self)
                    }
                    }, errorHandle: { (error) in
                        print(error)
                        //            ProgressHUD.dismiss()
                        OperationQueue.main.addOperation {
                            ProgressHUD.showError("The login or password incorrect!")
                        }
                })
                self.user = Profile(email: self.emailView.text!, password: self.passwordView.text!)
            } else {
                ProgressHUD.showError("All fieds should be not empty!")
            }
            
        }
       
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
        guard(navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No view controllers to pop off")
                return
        }
    }

    
    @IBAction func okPressed(_ sender: UIButton) {
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == goToMenu {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let root = appDelegate.switchRootViewController(nameStoryBoard: "MenuScreen", idViewController: MenuControllerID)
                    guard let dvc = root.children.first as? MenuViewController else { print("Not found destinationaViewController")
                        return }
//            guard let navigationVC = segue.destination as? UINavigationController else {
//                print("not found UINavigationController of MenuViewController")
//                return
//                
//            }
//            guard let dvc = navigationVC.topViewController as? MenuViewController else {
//                print("not found menuview controller")
//                return
//            }
            dvc.viewModel = viewModel?.goToTheMenu()
            
        } else if identifier == goToSignUp {
            if let dvc = segue.destination as? RegistrationViewController {
                dvc.viewModel = viewModel?.signUp()
            }
        }
        
    }
    
    @IBAction func goToRegistration(_ sender: UIButton) {
        self.performSegue(withIdentifier: goToSignUp, sender: self)

    }

    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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

