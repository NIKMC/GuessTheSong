//
//  LevelsCollectionModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol LevelsCollectionModelType {
    
    func numberOfItemsInSection() -> Int
    
    func itemViewModel(forIndexPath indexPath: IndexPath) -> CollectionViewCellModelType?
    
    func itemIsRunning(forIndexPath indexPath: IndexPath) -> Bool?
    
    func viewModelForSelectedItem(forIndexPath indexPath: IndexPath) -> PrepareGameModelType?
    
    func selectItem(atIndexPath indexPath: IndexPath)
    
    func updateSelectedItem() -> IndexPath?
    
}
