//
//  Box.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T) -> ()
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
    
    init(_ value: T) {
        self.value = value
    }
}
