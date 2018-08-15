//
//  CollectionViewCellModelType.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

protocol CollectionViewCellModelType: class {
    
    var title: String { get }
    var status: StatusLevel { get }
    
}
