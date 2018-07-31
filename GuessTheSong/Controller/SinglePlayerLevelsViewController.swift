//
//  SinglePlayerLevelsViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 28/04/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

class SinglePlayerLevelsViewController: UIViewController {
    
    @IBOutlet private weak var collectionLevelView: UICollectionView!
    private let reuseIdentifier = "LevelCell"
    private let leftAndRightPaddings : CGFloat = 20
    private let numberOfItemPerRow: CGFloat = 4
    
    var cellArray = [Level(1, StatusLevel.Done),Level(2, StatusLevel.Done),Level(3, StatusLevel.Ready),Level(4, StatusLevel.Closed),Level(5, StatusLevel.Done),Level(6, StatusLevel.Closed)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Configure the collectionView
//        let width = (collectionLevelView.frame.size.width - leftAndRightPaddings) / numberOfItemPerRow
        let width = (view.frame.size.width - leftAndRightPaddings) / numberOfItemPerRow
        let layout = collectionLevelView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(self.back(sender:)))
    }
    
    @objc func back(sender: AnyObject) {
//        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.LOGIN)
        guard(navigationController?.popViewController(animated: true)) != nil
            else {
                print("No view controllers to pop off")
                return
        }
    }
    
}

extension SinglePlayerLevelsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LevelViewCell
        cell.translatesAutoresizingMaskIntoConstraints = true
        
        print("size \(cell.frame)")
        print("size cell \(cell.frame.size.width)")
        print("size of view \( cell.viewCell.frame.size.width)")
        print("size dest \( cell.frame.size.width - cell.viewCell.frame.size.width)")
        
        cell.completedImage.center.x = cell.viewCell.frame.origin.x + cell.viewCell.frame.size.width + (cell.frame.size.width - cell.viewCell.frame.size.width)/2
        //bounds.size.width
        cell.completedImage.center.y = cell.viewCell.frame.origin.y + cell.viewCell.frame.size.height/4
            //cell.viewCell.bounds.size.height/3
        cell.viewCell.layer.borderWidth = 1
        cell.viewCell.layer.borderColor = UIColor.black.cgColor
        cell.viewCell.layer.cornerRadius = 5
        let level = cellArray[indexPath.item]
        switch level.status {
        case .Closed:
            cell.viewCell.backgroundColor = UIColor(red: 195.0/255.0, green: 161.0/255.0, blue: 50.0/255.0, alpha: 0.65)
            cell.completedImage.isHidden = true
            cell.closedImage.isHidden = false
            cell.levelText.text = ""
        case .Ready:
            //            cell.buttonCell.backgroundColor = UIColor(red: 195.0/255.0, green: 161.0/255.0, blue: 50.0/255.0, alpha: 1.0)
            cell.completedImage.isHidden = true
            cell.closedImage.isHidden = true
            cell.levelText.text = "\(level.id)"
        case .Done:
            //            cell.buttonCell.backgroundColor = UIColor(red: 195.0/255.0, green: 161.0/255.0, blue: 50.0/255.0, alpha: 1.0)
            cell.completedImage.isHidden = false
            cell.closedImage.isHidden = true
            cell.levelText.text = "\(level.id)"
        }
        
        // Configure the cell
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if cellArray[indexPath.item].status != .Closed {
            performSegue(withIdentifier: "goToPlayInTheGame", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlayInTheGame" {
            
            
            let destinationVC = segue.destination as? SinglePlayViewController
            if let indexPath = collectionLevelView.indexPathsForSelectedItems?.first {
                destinationVC?.id = "\(cellArray[indexPath.item].id)"
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        if cellArray[indexPath.item].status != .Closed {
            UIView.animate(withDuration: 0.5) {
                if let cell = collectionView.cellForItem(at: indexPath) as? LevelViewCell {
                    cell.transform = .init(scaleX: 0.95, y: 0.95)
                    cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if cellArray[indexPath.item].status != .Closed {
            UIView.animate(withDuration: 0.5) {
                if let cell = collectionView.cellForItem(at: indexPath) as? LevelViewCell {
                    cell.transform = .identity
                    cell.contentView.backgroundColor = .clear
                }
            }
        }
    }
    
}
