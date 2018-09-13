//
//  ViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class MainViewController: UIViewController {

    
    @IBOutlet var viewModel: MainViewModel!
    
    private let signUpIdentifier = "goToRegistration"
    private let signInIdentifier = "goToLogin"
    
    @IBOutlet weak var GSButtonLogin: UIGSButton!
    @IBOutlet weak var GSButtonRegistration: UIGSButton!
    @IBOutlet weak var GSButtonFB: UIGSButton!
    @IBOutlet weak var GSButtonGmail: UIGSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        socialInit()
        defaultInit()
        
    }
    
    func defaultInit() {
        
        GSButtonLogin.style = .normal
        GSButtonRegistration.style = .normal
        GSButtonFB.style = .facebook
        GSButtonGmail.style = .gmail
        
        GSButtonLogin.text = viewModel.buttonTextLogin()
        GSButtonRegistration.text = viewModel.buttonTextRegistration()
        GSButtonFB.text = viewModel.buttonTextFB()
        GSButtonGmail.text = viewModel.buttonTextGmail()
        
        
        GSButtonLogin.handler = { [unowned self] (button) in
            self.performSegue(withIdentifier: self.signInIdentifier, sender: button)
        }
        GSButtonRegistration.handler = { [unowned self] (button) in
            self.performSegue(withIdentifier: self.signUpIdentifier, sender: self)
        }
        GSButtonFB.handler = { (button) in
            //FIXME:  - uncommit this line when I decide that to do with token and email and I'l get results
            //        viewModel.signInFacebook()
            FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
                if error != nil {
                    print("login facebook failed: \(error)")
                }
                let token = result?.token.tokenString
                print(token)
                UserDefaults.standard.set(token, forKey: "FB_token")
                self.fetchProfileFromFB(token!)
            }
        }
        GSButtonGmail.handler = { (button) in
            //FIXME:  - uncommit this line when I decide that to do with token and email and I'l get results
            //viewModel.signInGmail()
            GIDSignIn.sharedInstance().signIn()
        }
    }
    func socialInit() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
//        NotificationCenter.default.addObserver(forName: .googleSignInNotification, object: nil, queue: .main, using: { [weak self] (notification) in
//            let userInGoogle = notification.object as? GIDGoogleUser
//            print("the result of clientId in addObserver \(String(describing: userInGoogle?.authentication.accessToken)) ")
//            print("the result of email in addObserver \(String(describing: userInGoogle?.profile.email)) ")
//            self?.viewModel.signInGmail()
//        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case signInIdentifier:
            guard let dvc = segue.destination as? LoginViewController else { return }
            dvc.viewModel = viewModel.signIn()
        case signUpIdentifier:
            guard let dvc = segue.destination as? RegistrationViewController else { return }
            dvc.viewModel = viewModel.signUp()
        default:
            return
        }
    }
    
    
    func fetchProfileFromFB(_ token: String) {
        print("The token of Facebook is \(token)")
        let parametrs = ["fields": "email, first_name, last_name"]
        FBSDKGraphRequest(graphPath: "me", parameters: parametrs).start { (connection, result, error) in
            if error != nil {
                print(error)
                return
            }
            
            print(result)
            
            if let result = result as? NSDictionary {
                if let email = result["email"] as? String {
                    print("The email result \(email)")
                }
            }
            
        }
    }
    
   
}

extension MainViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        // myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //completed sign In
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let accessToken = user.authentication.accessToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("The result here)")
            print("userID \(String(describing: userId))")
            print("idToken \(String(describing: idToken))")
            print("accessToken \(String(describing: accessToken))")
            print("fullName \(String(describing: fullName))")
            print("givenName \(String(describing: givenName))")
            print("familyName \(String(describing: familyName))")
            print("email \(String(describing: email))")
            UserDefaults.standard.set(accessToken, forKey: "Google_token")
            // ...
            viewModel.signInGmail()
        } else {
            print("Failed to log into google \(error.localizedDescription)")
        }
    }
    
}
