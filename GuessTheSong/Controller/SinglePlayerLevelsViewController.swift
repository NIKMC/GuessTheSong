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
    
    var shapeLayer: CAShapeLayer! {
        didSet {
            shapeLayer.lineWidth = 7
            shapeLayer.lineCap = "round"
            shapeLayer.fillColor = nil
            shapeLayer.strokeEnd = 1
            let color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
            shapeLayer.strokeColor = color
        }
    }
    
    var overShapeLayer: CAShapeLayer! {
        didSet {
            overShapeLayer.lineWidth = 6
            overShapeLayer.lineCap = "round"
            overShapeLayer.fillColor = nil
            overShapeLayer.strokeEnd = 0
            let color = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1).cgColor
            overShapeLayer.strokeColor = color
            let borderColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1).cgColor
            overShapeLayer.borderColor = borderColor
            overShapeLayer.borderWidth = 2
        }
    }
    
    
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
        shapeLayer = CAShapeLayer()
        self.view.layer.addSublayer(shapeLayer)
        
        overShapeLayer = CAShapeLayer()
        self.view.layer.addSublayer(overShapeLayer)
        
//        self.navigationItem.hidesBackButton = true
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(self.back(sender:)))
    }
    
    
    override func viewDidLayoutSubviews() {
        configShapeLayerLevel(shapeLayer)
        configShapeLayerLevel(overShapeLayer)
        overShapeLayer.strokeEnd = 0.4
    }
    
    func configShapeLayerLevel(_ shapeLayer: CAShapeLayer) {
        shapeLayer.frame = view.bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.view.frame.size.width / 10, y: self.view.frame.size.height/2))
        path.addLine(to: CGPoint(x: self.view.frame.size.width - 50, y: self.view.frame.size.height/2))
        shapeLayer.path = path.cgPath
    }
    
    @objc func back(sender: AnyObject) {
        guard(navigationController?.popViewController(animated: true)) != nil
            else {
                print("No view controllers to pop off")
                return
        }
    }
    //TODO: replace on the refresh, not to load full data
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
