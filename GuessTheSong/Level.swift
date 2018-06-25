//
//  Level.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 28/04/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class Level {
    var id: Int
    var status: StatusLevel
    
    init(_ idLevel: Int,_ statusLevel: StatusLevel) {
        self.id = idLevel
        self.status = statusLevel
    }
}

enum StatusLevel: String {
    case Done
    case Closed
    case Ready
}
