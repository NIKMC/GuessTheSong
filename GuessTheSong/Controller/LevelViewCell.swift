//
//  LevelViewCell.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/05/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

class LevelViewCell: UICollectionViewCell {
    
    @IBOutlet weak var completedImage: UIImageView!
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var closedImage: UIImageView!
    
    @IBOutlet weak var levelText: UILabel!
    
    weak var viewModel: CollectionViewCellModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            
            viewCell.layer.borderWidth = 1
            viewCell.layer.borderColor = UIColor.black.cgColor
            viewCell.layer.cornerRadius = 5
            
            let status = viewModel.status
            switch status {
            case StatusLevel.closed.rawValue:
                viewCell.backgroundColor = UIColor(red: 195.0/255.0, green: 161.0/255.0, blue: 50.0/255.0, alpha: 0.65)
                completedImage.isHidden = true
                closedImage.isHidden = false
                levelText.text = ""
            case StatusLevel.running.rawValue:
                viewCell.backgroundColor = UIColor(red: 195.0/255.0, green: 161.0/255.0, blue: 50.0/255.0, alpha: 1.0)
                completedImage.isHidden = true
                closedImage.isHidden = true
                levelText.text = "\(viewModel.title)"
            case StatusLevel.done.rawValue:
                viewCell.backgroundColor = UIColor(red: 195.0/255.0, green: 161.0/255.0, blue: 50.0/255.0, alpha: 1.0)
                completedImage.isHidden = false
                closedImage.isHidden = true
                levelText.text = "\(viewModel.title)"
                //FIXME: wrong add completed image after refreshing
                completedImage.center.x = viewCell.layer.frame.origin.x + viewCell.layer.frame.size.width + (frame.size.width - viewCell.layer.frame.size.width)/2
                completedImage.center.y = viewCell.layer.frame.origin.y + viewCell.layer.frame.size.height/4
            default:
                completedImage.isHidden = true
                closedImage.isHidden = true
                levelText.text = "\(viewModel.title)"
            }
        }
    }
    
}
