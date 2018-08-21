//
//  GamePlayViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 08/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController,UITextFieldDelegate {

    //TODO: I need create a struct which will used to determine singleplay or multyPlay
    @IBOutlet weak var scoreTitleLabelText: UILabel!
    @IBOutlet weak var textLabelText: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var life1: UIImageView!
    @IBOutlet weak var life2: UIImageView!
    @IBOutlet weak var life3: UIImageView!
    
    var viewModel: SinglePlayModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for value in 0..<3 {
            let sampleTextField = UITextField(frame: CGRect(x: 20, y: 20 + 40 * value, width: Int(containerView.frame.size.width - 40), height: 40))
            sampleTextField.attributedPlaceholder = NSAttributedString(string: "Placeholder Text \(value)", attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.boldSystemFont(ofSize: 14.0)
                ])
            sampleTextField.font = UIFont.systemFont(ofSize: 15)
            sampleTextField.borderStyle = UITextBorderStyle.roundedRect
            sampleTextField.autocorrectionType = UITextAutocorrectionType.no
            sampleTextField.keyboardType = UIKeyboardType.default
            sampleTextField.returnKeyType = UIReturnKeyType.done
            sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
            sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            sampleTextField.delegate = self
            containerView.addSubview(sampleTextField)

        }
        
        
    }
    
    func prepareTextOfSong() {
        
    }
    
    func prepareAnswersOfSong() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
