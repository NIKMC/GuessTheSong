//
//  SinglePlayViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/05/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import AVFoundation
import ProgressHUD

class PrepareSinglePlayViewController: UIViewController {

    private let goToPlay = "goToPlay"
    private let GameControllerID = "GameControllerID"
    var id:String = ""
    var audioPlayer:AVAudioPlayer!
    var destinations: [URL?]?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchText: UILabel!
    
    var viewModel: PrepareGameModelType?
    
    @IBOutlet weak var circleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(self.refreshDownloadMusic(sender:)))
        
        loadingIndicator.color = UIColor(red: 235/255, green: 167/255, blue: 0/255, alpha: 1.0)
        loadingIndicator.scale(factor: 5.0)
        
        // Do any additional setup after loading the view.
        addCircleView(circle: circleView)        
        processLoadingSongs()
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
        viewModel?.prepareDataForStartGame(completion: { [weak self] in
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
            self?.stopLoading()
            self?.performSegue(withIdentifier: (self?.goToPlay)!, sender: self)
        }, errorHandle: { [weak self] (errorMessage) in
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
            self?.stopLoading()
            ProgressHUD.showError(errorMessage)
        })
    }

    func stopLoading() {
        if loadingIndicator.isAnimating {
            loadingIndicator.stopAnimating()
        }
    }
    
    private func addCircleView(circle: UIView) {
        
        if AppDelegate.isIPhoneSE() {
            let size = self.view.frame.size.width - 100
            circle.frame.size.width = size
            circle.frame.size.height = size
        }
        circle.center = self.view.center
        circle.layer.cornerRadius = circleView.frame.width / 2
        circle.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        circle.clipsToBounds = true
    
    
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
    
        blurView.frame = circle.bounds
    
        circle.addSubview(blurView)
        circle.addSubview(loadingIndicator)
        self.view.addSubview(circle)
    
    }
    
    func startLoading() {
        if !loadingIndicator.isAnimating {
            loadingIndicator.startAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == goToPlay {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let root = appDelegate.switchRootViewController(nameStoryBoard: "GameScreen", idViewController: GameControllerID)
            guard let dvc = root.childViewControllers.first as? GamePlayViewController else { print("Not found destinationaViewController")
                return }
            
//            guard let navigationVC = segue.destination as? UINavigationController else {
//                print("not found UINavigationController of MenuViewController")
//                return
//
//            }
//            guard let dvc = navigationVC.topViewController as? GamePlayViewController else {
//                print("not found menuview controller")
//                return
//            }
             dvc.viewModel = viewModel?.goToPlaySinglePlay()
        }
    }
}

extension UIActivityIndicatorView {
    func scale(factor: CGFloat) {
        guard factor > 0.0 else { return }
        
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}
