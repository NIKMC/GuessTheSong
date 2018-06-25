//
//  LevelData.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 30/05/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import RealmSwift

class LevelData: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var status: String = "Closed"
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
