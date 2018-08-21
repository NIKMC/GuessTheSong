//
//  CollectionViewCellViewModel.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class CollectionViewCellViewModel: CollectionViewCellModelType {
   
    private var level: Int
    private var statusOfLevel: String
    
    var title: String  {
        return String(describing: level)
    }
    
    var status: StatusLevel.RawValue {
        return statusOfLevel
    }
    
    init(level: Int, status: StatusLevel.RawValue) {
        self.level = level
        self.statusOfLevel = status
    }
    
}
