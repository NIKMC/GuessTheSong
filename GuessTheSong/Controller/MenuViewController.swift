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
import SwiftyJSON

class MenuViewController: UIViewController {

    
    let defaults = UserDefaults.standard
    
//    var delegate: ResponseDelegate?
    var viewModel: MenuModelType?
    private let goToSinglePlay = "singlePlayTapped"
    private let goToMultyPlay = "multyPlayTapped"
    private let MainControllerID = "MainControllerID"
    private let goToMain = "goToMain"
    override func viewDidLoad() {
        super.viewDidLoad()

//        Socket_API.sharedInstance.delegate = self
//        Socket_API.sharedInstance.connect(connection: .User)
//        Socket_API.sharedInstance.profileResponseEvent()
//        ProgressHUD.showSuccess()
        if let login = defaults.value(forKey: "token") as? String {
            print( "The token is \(login)")
        } else {
            print("Not the Login")
        }
        viewModel?.showProfileInfo(completion: { (profile) in
            print("get profile ok")
            print("username from get my profile is \(profile.username)")
        }, errorHandle: { (error) in
            print(error)
            ProgressHUD.showError(error)
        })
        
        
    }

    
    @IBAction func singleTapped(_ sender: UIButton) {
        performSegue(withIdentifier: goToSinglePlay, sender: sender)
    }
    
    @IBAction func multiTapped(_ sender: UIButton) {
        performSegue(withIdentifier: goToMultyPlay, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == goToMultyPlay {
//            if let dvc = segue.destination as? PrepareMultiPlayViewController {
//                dvc.viewModel = viewModel?.signUp()
//            }
        } else if identifier == goToMain {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let root = appDelegate.switchRootViewController(nameStoryBoard: "Main", idViewController: MainControllerID)
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
