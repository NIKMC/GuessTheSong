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
            let status = viewModel.status
            switch status {
            case StatusLevel.Closed.rawValue:
                viewCell.backgroundColor = UIColor(red: 195.0/255.0, green: 161.0/255.0, blue: 50.0/255.0, alpha: 0.65)
                completedImage.isHidden = true
                closedImage.isHidden = false
                levelText.text = ""
            case StatusLevel.Ready.rawValue:
                //            cell.buttonCell.backgroundColor = UIColor(red: 195.0/255.0, green: 161.0/255.0, blue: 50.0/255.0, alpha: 1.0)
                completedImage.isHidden = true
                closedImage.isHidden = true
                levelText.text = "\(viewModel.title)"
            case StatusLevel.Done.rawValue:
                //            cell.buttonCell.backgroundColor = UIColor(red: 195.0/255.0, green: 161.0/255.0, blue: 50.0/255.0, alpha: 1.0)
                completedImage.isHidden = false
                closedImage.isHidden = true
                levelText.text = "\(viewModel.title)"
            default:
                completedImage.isHidden = true
                closedImage.isHidden = true
                levelText.text = "\(viewModel.title)"
            }
        }
    }
    
}
