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

    
    @IBOutlet var viewModel: MainViewModel!
    
    private let signUpIdentifier = "goToRegistration"
    private let signInIdentifier = "goToLogin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        performSegue(withIdentifier: signInIdentifier, sender: self)
    }
    
    
    @IBAction func registrationPressed(_ sender: UIButton) {
        performSegue(withIdentifier: signUpIdentifier, sender: self)
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
    
    @IBAction func signInWithFacebook(_ sender: UIButton) {
        viewModel.signInFacebook()
    }
    
    @IBAction func signInWithGmail(_ sender: UIButton) {
        viewModel.signInGmail()
    }
}
