//
//  SinglePlayViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/05/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import AVFoundation

class PrepareSinglePlayViewController: UIViewController {

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
        viewModel?.getDestinationUrl(completionUrl: { [weak self] (destinationUrls) in
            self?.destinations = destinationUrls
            print("destination Url is \(String(describing: self?.destinations?.first))")
        })
    }

    @IBAction func stopLoading(_ sender: UIButton) {
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
    
    @IBAction func startLoading(_ sender: UIButton) {
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
    @IBAction func goToPlayInGame(_ sender: Any) {
        performSegue(withIdentifier: "goToPlay", sender: sender)
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
