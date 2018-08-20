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
    var id:String = ""
    var audioPlayer:AVAudioPlayer!
    var destinations: [URL?]?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchText: UILabel!
    
    var viewModel: PrepareGameModelType?
    
    @IBOutlet weak var circleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.color = UIColor(red: 235/255, green: 167/255, blue: 0/255, alpha: 1.0)
        loadingIndicator.scale(factor: 5.0)
        // Do any additional setup after loading the view.
        addCircleView(circle: circleView)        
        processLoadingSongs()
    }
    
    func processLoadingSongs() {
        startLoading()
        viewModel?.prepareDataForStartGame(completion: { [weak self] in
            self?.stopLoading()
            self?.performSegue(withIdentifier: (self?.goToPlay)!, sender: self)
        }, errorHandle: { [weak self] (errorMessage) in
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
        } else {
//            circle
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
//        circle.addSubview(searchText)
        self.view.addSubview(circle)
    
    }
    
    func startLoading() {
        if !loadingIndicator.isAnimating {
            loadingIndicator.startAnimating()
        }
    }
    
    @IBAction func playMusic(_ sender: UIButton) {
        guard let destinationURLFirst = destinations?[0] else {
            print("no first value")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: destinationURLFirst)
            guard let player = audioPlayer else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    
    }
    
    @IBAction func stopMusic(_ sender: UIButton) {
        guard let player = audioPlayer else { return }
        player.stop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == goToPlay {
            if let dvc = segue.destination as? GamePlayViewController {
                dvc.viewModel = viewModel?.goToPlaySinglePlay()
            }
        }
    }
    
    @IBAction func nextTrack(_ sender: UIButton) {
        guard let _ = destinations?.remove(at: 0) else {
            print("error deleting")
            return
        }
        guard let destinationURLFirst = destinations?[0] else {
            print("no next value")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: destinationURLFirst)
            guard let player = audioPlayer else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

extension UIActivityIndicatorView {
    func scale(factor: CGFloat) {
        guard factor > 0.0 else { return }
        
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}
