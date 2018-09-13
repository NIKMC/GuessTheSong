//
//  FinishGameViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 08/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

class FinishGameViewController: UIViewController {

    @IBOutlet weak var finishGameImage: UIImageView!
    
    @IBOutlet weak var GSButtonFinishGame: UIGSButton!
    
    var viewModel: FinishGameModelType?
    private let goToMain = "goToMain"
    private let goToMulty = "goToMultyPlayer"
    private let MenuControllerID = "MenuControllerID"
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        defaultInit(viewModel: viewModel)
        
        
    }
    
    func defaultInit(viewModel: FinishGameModelType) {
        let behaviour = viewModel.getBehaviour()
        finishGameImage.image = viewModel.getImage()
        
        GSButtonFinishGame.style = .rich
        
        GSButtonFinishGame.text = viewModel.getButtonTitle()
        
        
        GSButtonFinishGame.handler = { [unowned self] (button) in
            let behaviour = viewModel.getBehaviour()
            switch behaviour {
            case .WinMulty:
                self.performSegue(withIdentifier: self.goToMulty, sender: button)
            case .LoseMulty:
                self.performSegue(withIdentifier: self.goToMulty, sender: button)
            case .WinSingle:
                //            self.dismiss(animated: true)
                self.performSegue(withIdentifier: self.goToMain, sender: button)
                //            let storyboard = UIStoryboard(name: "MenuScreen", bundle: nil)
                //            let vc = storyboard.instantiateViewController(withIdentifier: "SinglePlayerLevelsVCID") as! SinglePlayerLevelsViewController
            //            present(vc, animated: true)
            case .LoseSingle:
                self.performSegue(withIdentifier: self.goToMain, sender: button)
            }
        }
        switch behaviour {
        case .WinMulty:
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Main", style: .plain, target: self, action: #selector(self.goToMain(sender:)))
        case .LoseMulty:
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.goToMain(sender:)))
        default:
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "goToMain", style: .plain, target: self, action: #selector(self.goToMain(sender:)))
        }
    }
    
    
    
    @objc func goToMain(sender: AnyObject) {
        self.dismiss(animated: true)
        performSegue(withIdentifier: goToMain, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        guard let viewModel = viewModel else { return }
        
        switch identifier {
        case goToMain:
            print("goToMain")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let root = appDelegate.switchRootViewController(nameStoryBoard: "MenuScreen", idViewController: MenuControllerID)
            guard let dvc = root.childViewControllers.first as? MenuViewController else { print("Not found destinationaViewController")
                return }
            
//            let storyboard = UIStoryboard(name: "MenuScreen", bundle: nil)
//            guard let navigationVC = storyboard.instantiateInitialViewController() as? UINavigationController else {
//                print("not found UINavigationController of MenuViewController")
//                return
//
//            }
//            guard let dvc = navigationVC.topViewController as? MenuViewController else {
//                print("not found menuview controller")
//                return
//            }
            dvc.viewModel = viewModel.goToMenu()
        case goToMulty:
            guard let _ = segue.destination as? PrepareMultiPlayViewController else { return }
//            dvc.viewModel = viewModel.goToPlayAgain()
        default:
            return
        }
    }
}
