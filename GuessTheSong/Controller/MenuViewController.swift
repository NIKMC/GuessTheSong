//
//  ExampleViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import ProgressHUD
//import SocketIO
//import SwiftyJSON

class MenuViewController: UIViewController {

    
    let defaults = UserDefaults.standard
    
//    var delegate: ResponseDelegate?
    var viewModel: MenuModelType?
    private let goToSinglePlay = "singlePlayTapped"
    private let goToMultyPlay = "multyPlayTapped"
    private let MainControllerID = "MainControllerID"
    private let goToMain = "goToMain"
    
    @IBOutlet weak var GSButtonSingle: UIGSButton!
    @IBOutlet weak var GSButtonMulti: UIGSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultInit()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let login = defaults.value(forKey: "token") as? String {
            print( "The token is \(login)")
        } else {
            print("Not the Login")
        }
        viewModel?.showProfileInfo(completion: {
            print("get profile ok")
        }, errorHandle: { (error) in
            print(error)
            ProgressHUD.showError(error)
        })
    }
    
    func defaultInit() {
        
        GSButtonSingle.style = .rich
        GSButtonMulti.style = .rich
        
        GSButtonSingle.text = viewModel?.buttonTextSingle()
        GSButtonMulti.text = viewModel?.buttonTextMulty()
        
        
        GSButtonSingle.handler = { [unowned self] (button) in
            self.performSegue(withIdentifier: self.goToSinglePlay, sender: button)
        }
        GSButtonMulti.handler = { [unowned self] (button) in
            self.performSegue(withIdentifier: self.goToMultyPlay, sender: button)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == goToMultyPlay {
            if let dvc = segue.destination as? PrepareMultiPlayViewController {
                dvc.viewModel = viewModel?.multiPlay()
            }
        } else if identifier == goToMain {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let _ = appDelegate.switchRootViewController(nameStoryBoard: "Main", idViewController: MainControllerID)
            //        guard let dvc = root.childViewControllers.first as? SignUpViewController else { print("Not found destinationaViewController")
            //            return }
        }
        
        
    }
    
    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
//        guard(navigationController?.popToRootViewController(animated: true)) != nil
//            else {
//                print("No view controllers to pop off")
//                return
//        }
       

        performSegue(withIdentifier: goToMain, sender: sender)
    }
    
    @IBAction func profileInfo(_ sender: UIButton) {

    }
    
}

//extension MenuViewController: ResponseProfileDelegate {
//    func success() {
//        print("success")
//    }
//
//    func informErrorMessage(error: String) {
//        print("the error is \(error)")
//        ProgressHUD.showError(error)
//    }
//
//    func informDisconnectedMessage() {
//        print("the socket was disconnected")
////        ProgressHUD.showError("Check your Internet connection ")
////
//        guard(navigationController?.popToRootViewController(animated: true)) != nil
//            else {
//                print("No view controllers to pop off")
//                return
//        }
//    }
//
//    func printErrorMessage(error: String?) {
//        print("Login error in delegate")
//        if let errorMessage = error {
//            print("Error message \(errorMessage)")
//        }
//    }
//
//
//}
//
