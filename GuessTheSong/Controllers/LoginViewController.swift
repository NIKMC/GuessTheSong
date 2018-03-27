//
//  LoginViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
    }

    @IBAction func LoginPressed(_ sender: UIButton) {
        defaults.setValue("QwertyLogin", forKey: "loginKey")
        
    }
    

}
