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
    
    private let DEFAULT_SET = 100
    private let DEFAULT_SIZE = 20
    
    var pageSize: Int
    var pageOffSet: Int
    
    
    func numberOfItemsInSection() -> Int {
        return levels?.count ?? 0
    }
    
    func getStatusLevel() -> (Int, Double) {
        guard let level = UserDefaults.standard.string(forKey: "single_player_experience") else {
            return (0, 0)
        }
        let value = Int(level)!
        let score = value / 10
        let progress: Double = (Double(value % 10)/10)
//        let score = Int(floor(value))
//        let progress = Double(value.truncatingRemainder(dividingBy: 1)).rounded()
        return (score, progress)
    }
    
    func itemViewModel(forIndexPath indexPath: IndexPath) -> CollectionViewCellModelType? {
        guard let levels = levels else { return nil }
        let currentLevel = levels[indexPath.item]
        return CollectionViewCellViewModel(level: currentLevel.getLevelURL(), status: currentLevel.status)
    }
    
    func itemIsRunning(forIndexPath indexPath: IndexPath) -> Bool? {
        guard let levels = levels else { return nil }
        let currentLevel = levels[indexPath.item]
        return currentLevel.status == StatusLevel.running.rawValue ? true : false
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
        //FIXME: change on the Static class with variable token
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            errorHandle?("Error update token")
            return
        }
        levelsNetworkManager = ListOfLevelsOperation(token: token)
        levelsNetworkManager?.start()
        levelsNetworkManager?.success = { (levels) in
            print("the result is ok \(levels)")
            completion?(levels.sorted(by: {$0.id < $1.id}))
        }
        
        levelsNetworkManager?.failure = { (error) in
            print("error of loading indfo about level \(error)")
            ErrorValidator().chooseActionAfterResponse(errorResponse: error, success: { [weak self] () in
                self?.loadingLevels(completion: completion, errorHandle: errorHandle)
                }, failure: { (errorMessage) in
                    errorHandle?(errorMessage.localizedDescription)
            })
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
