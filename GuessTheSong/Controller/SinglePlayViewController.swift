//
//  SinglePlayViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/05/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

class SinglePlayViewController: UIViewController {

    var id:String = ""
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var IdLevel: UILabel!
    @IBOutlet weak var searchText: UILabel!
    
    @IBOutlet weak var circleView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        IdLevel.text = id
        loadingIndicator.color = UIColor(red: 235/255, green: 167/255, blue: 0/255, alpha: 1.0)
        loadingIndicator.scale(factor: 2.0)
        // Do any additional setup after loading the view.
        addCircleView(circle: circleView)
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
        circle.addSubview(searchText)
        self.view.addSubview(circle)
    
    }
    
    @IBAction func startLoading(_ sender: UIButton) {
        if !loadingIndicator.isAnimating {
            loadingIndicator.startAnimating()
        }
        
    }
    
}

extension UIActivityIndicatorView {
    func scale(factor: CGFloat) {
        guard factor > 0.0 else { return }
        
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}
