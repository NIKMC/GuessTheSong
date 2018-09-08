//
//  SinglePlayerLevelsViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 28/04/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import ProgressHUD

class SinglePlayerLevelsViewController: UIViewController {
    
    @IBOutlet private weak var collectionLevelView: UICollectionView!
    private let reuseIdentifier = "LevelCell"
    private let identityGoToPlayInTheGame = "goToPlayInTheGame"
    private let leftAndRightPaddings : CGFloat = 20
    private let numberOfItemPerRow: CGFloat = 4
    
    //TODO: create request update collectionview by pullToRefresh
    @IBOutlet var viewModel: LevelsOfSinglePlayViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(self.refreshLevels(sender:)))
        
        //Configure the collectionView
//        let width = (collectionLevelView.frame.size.width - leftAndRightPaddings) / numberOfItemPerRow
        let width = (view.frame.size.width - leftAndRightPaddings) / numberOfItemPerRow
        let layout = collectionLevelView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        loadLevels()
        
//        self.navigationItem.hidesBackButton = true
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(self.back(sender:)))
    }
    
    @objc func back(sender: AnyObject) {
//        Socket_API.sharedInstance.resetResponseEvent(eventName: EventName.LOGIN)
        guard(navigationController?.popViewController(animated: true)) != nil
            else {
                print("No view controllers to pop off")
                return
        }
    }
    //TODO: replace on the refresh, not to load full data
    //FIXME: not correctly update UI after refresh
    @objc func refreshLevels(sender: AnyObject) {
        loadLevels()
    }
    
    func loadLevels() {
        ProgressHUD.show()
        viewModel.fetchListOfLevels(completion: { [weak self] in
            ProgressHUD.dismiss()
            OperationQueue.main.addOperation {
                self?.collectionLevelView.reloadData()
            }
        }) { (errorMessage) in
            //            ProgressHUD.dismiss()
            ProgressHUD.showError(errorMessage)
        }
    }
    
}

extension SinglePlayerLevelsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSections(in: collectionView, count: viewModel.numberOfItemsInSection())
    }
    
    func numberOfSections(in collectionView: UICollectionView, count numOfSections: Int) -> Int {
        if numOfSections > 0 {
            collectionView.backgroundView = nil
        } else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: collectionView.bounds.size.height/4, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height/2))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
        }
        return numOfSections
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? LevelViewCell
        guard let cell = collectionViewCell, let viewModel = viewModel else { return UICollectionViewCell() }
        
        let itemViewModel = viewModel.itemViewModel(forIndexPath: indexPath)
        cell.viewModel = itemViewModel

//        cell.translatesAutoresizingMaskIntoConstraints = true
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let notClosed = viewModel.itemIsNotClosed(forIndexPath: indexPath) else { return }
        if notClosed {
            performSegue(withIdentifier: identityGoToPlayInTheGame, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identityGoToPlayInTheGame {
            if let dvc = segue.destination as? PrepareSinglePlayViewController, let indexPath = collectionLevelView.indexPathsForSelectedItems?.first {
                dvc.viewModel = viewModel.viewModelForSelectedItem(forIndexPath: indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        guard let notClosed = viewModel.itemIsNotClosed(forIndexPath: indexPath) else { return }
        if notClosed {
            UIView.animate(withDuration: 0.5) {
                if let cell = collectionView.cellForItem(at: indexPath) as? LevelViewCell {
                    cell.transform = .init(scaleX: 0.95, y: 0.95)
                    cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let notClosed = viewModel.itemIsNotClosed(forIndexPath: indexPath) else { return }
        if notClosed {
            UIView.animate(withDuration: 0.5) {
                if let cell = collectionView.cellForItem(at: indexPath) as? LevelViewCell {
                    cell.transform = .identity
                    cell.contentView.backgroundColor = .clear
                }
            }
        }
    }
    
}
