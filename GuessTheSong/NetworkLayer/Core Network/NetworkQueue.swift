//
//  MetworkQueue.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 18/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class NetworkQueue {
    public static var shared: NetworkQueue!
    
    let queue = OperationQueue()
    
    public init() {}
    
    public func addOperation(_ op: Operation) {
        queue.addOperation(op)
    }
}
