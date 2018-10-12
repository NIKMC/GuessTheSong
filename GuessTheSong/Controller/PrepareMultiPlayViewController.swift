//
//  MultiPlayerViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 08/06/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import ProgressHUD
import Starscream


class PrepareMultiPlayViewController: UIViewController {
  
    private let goToPlay = "goToPlay"
    private let GameControllerID = "GameMultiControllerID"
    @IBOutlet weak var searchText: UILabel!
    
    var viewModel: PrepareMultiPlayerViewModel?
    
    @IBOutlet weak var loaderView: UISpinner!
    var observer: NSObjectProtocol?

    
    private var roomID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(self.refreshDownloadMusic(sender:)))
        
//        ProgressHUD.show()
        processLoadingSongs()
        
        loaderView.background = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4003103596)
        loaderView.starCount = 20
        loaderView.distance = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observer = NotificationCenter.default.addObserver(forName: .socket, object: nil, queue: .main, using: { [weak self] (notification) in
            let notifier = notification.object as! PrepareMultiPlayerViewModel
            if notifier.errorHandlerMessage != nil {
                OperationQueue.main.addOperation {
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                    self?.stopLoading()
                    ProgressHUD.showError(notifier.errorHandlerMessage!)
                }
            } else {
                if notifier.status {
                    OperationQueue.main.addOperation {
                        self?.navigationItem.rightBarButtonItem?.isEnabled = true
                        self?.stopLoading()
                        self?.performSegue(withIdentifier: (self?.goToPlay)!, sender: self)
                    }
                }
            }
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }
    
    
    @objc func refreshDownloadMusic(sender: AnyObject) {
        processLoadingSongs()
    }
    
    @objc func back(sender: AnyObject) {
        guard(navigationController?.popViewController(animated: true)) != nil
            else {
                print("No view controllers to pop off")
                return
        }
    }
    
    func processLoadingSongs() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        startLoading()
        viewModel?.prepareDataForStartGame(errorHandle: { [weak self] (errorMessage) in
            OperationQueue.main.addOperation {
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                self?.stopLoading()
                ProgressHUD.showError(errorMessage)
            }
        })
    }
    
    func stopLoading() {
        loaderView.animate = false
    }
    
    func startLoading() {
        loaderView.animate = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == goToPlay {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let root = appDelegate.switchRootViewController(nameStoryBoard: "MultiPlayGameScreen", idViewController: GameControllerID)
            guard let dvc = root.childViewControllers.first as? MultiPlayViewController else { print("Not found destinationaViewController")
                return }
            dvc.viewModel = viewModel?.goToPlayMyltiPlayer()
        }
    }
}
