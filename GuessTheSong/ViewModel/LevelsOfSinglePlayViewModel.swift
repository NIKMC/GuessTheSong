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
//    private var levels: [Level]? = [Level(1, StatusLevel.Done),Level(2, StatusLevel.Done),Level(3, StatusLevel.Ready),Level(4, StatusLevel.Closed),Level(5, StatusLevel.Done),Level(6, StatusLevel.Closed)]
    
//    private var storage: StorableContext
    
    private var levels: [GameResponse]?
    private var levelsNetworkManager: ListOfLevelsOperation?
    private var token: String = ""
    
    private let DEFAULT_SET = 100
    private let DEFAULT_SIZE = 20
    
    var pageSize: Int
    var pageOffSet: Int
    
    
    func numberOfItemsInSection() -> Int {
        return levels?.count ?? 0
    }
    
    func itemViewModel(forIndexPath indexPath: IndexPath) -> CollectionViewCellModelType? {
        guard let levels = levels else { return nil }
        let currentLevel = levels[indexPath.item]
        return CollectionViewCellViewModel(level: currentLevel.getLevelURL(), status: currentLevel.status)
    }
    
    func itemIsNotClosed(forIndexPath indexPath: IndexPath) -> Bool? {
        guard let levels = levels else { return nil }
        let currentLevel = levels[indexPath.item]
        return currentLevel.status != StatusLevel.closed.rawValue ? true : false
    }
    
    func viewModelForSelectedItem(forIndexPath indexPath: IndexPath) -> PrepareGameModelType? {
        guard let levels = levels else { return nil }
        let currentLevel = levels[indexPath.item]
        return PrepareSinglePlayViewModel(level: currentLevel.getLevelURL(), idGame: currentLevel.getGameURL())
    }
    
    func selectItem(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func updateSelectedItem() -> IndexPath? {
        return self.selectedIndexPath
    }
    
    //TODO: I need to think about cache levels
    func fetchListOfLevels(completion: (()->())?, errorHandle: ((String)->())?) {
        loadingLevels(completion: { [weak self] (results) in
            self?.levels?.removeAll()
            self?.levels?.append(contentsOf: results)
            completion?()
        }) { (errorMessage) in
            errorHandle?(errorMessage)
        }
    }
    
    
    func loadingLevels(completion: (([GameResponse])->())?, errorHandle: ((String)->())?) {
        levelsNetworkManager = ListOfLevelsOperation(token: token)
        levelsNetworkManager?.start()
        levelsNetworkManager?.success = { (levels) in
            print("the result is ok \(levels)")
            completion?(levels)
        }
        
        levelsNetworkManager?.failure = { (error) in
            print("error of loading indfo about level \(error)")
            errorHandle?(error.localizedDescription)
        }
    }
    
    override init() {
        self.pageSize = DEFAULT_SIZE
        self.pageOffSet = DEFAULT_SET
        self.levels = [GameResponse]()
//        guard let realm = try? RealmStorageContext() else { print("error")}
//        self.storage = realm
        
//        guard self.storage = try RealmStorageContext() as StorageContext else { return }
        
    }
    
    
}
