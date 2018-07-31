//
//  File.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 18/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public protocol BackendService {
    func request(_ request: BackendAPIRequest,
                 success: ((Data)->())?,
                 failure: ((NSError)->())?)
    
    func cancel()
}
