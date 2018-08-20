//
//  CollectionViewCellViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class CollectionViewCellViewModel: CollectionViewCellModelType {
   
    private var level: String
    private var statusOfLevel: String
    
    var title: String  {
        return level
    }
    
    var status: StatusLevel.RawValue {
        return statusOfLevel
    }
    
    init(level: String, status: StatusLevel.RawValue) {
        self.level = level
        self.statusOfLevel = status
    }
    
}
