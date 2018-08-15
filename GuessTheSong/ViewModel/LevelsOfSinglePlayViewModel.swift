//
//  SinglePlayerLevelsViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class LevelsOfSinglePlayViewModel: NSObject, LevelsCollectionModelType {
    
    private var selectedIndexPath: IndexPath?
    private var levels: [Level]? = [Level(1, StatusLevel.Done),Level(2, StatusLevel.Done),Level(3, StatusLevel.Ready),Level(4, StatusLevel.Closed),Level(5, StatusLevel.Done),Level(6, StatusLevel.Closed)]
    
    func numberOfItemsInSection() -> Int {
        return levels?.count ?? 0
    }
    
    func itemViewModel(forIndexPath indexPath: IndexPath) -> CollectionViewCellModelType? {
        guard let levels = levels else { return nil }
        let currentLevel = levels[indexPath.item]
        return CollectionViewCellViewModel(level: currentLevel)
    }
    
    func itemIsNotClosed(forIndexPath indexPath: IndexPath) -> Bool? {
        guard let levels = levels else { return nil }
        let currentLevel = levels[indexPath.item]
        return currentLevel.status != .Closed
    }
    
    func viewModelForSelectedItem(forIndexPath indexPath: IndexPath) -> PrepareGameModelType? {
        guard let levels = levels else { return nil }
        let currentLevel = levels[indexPath.item]
        return PrepareSinglePlayViewModel(level: currentLevel)
    }
    
    func selectItem(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func updateSelectedItem() -> IndexPath? {
        return self.selectedIndexPath
    }
    
    
    
    
}
