//
//  NetworkOperation.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 18/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class NetworkOperation: Operation {
    private var _isReady: Bool
    public override var isReady: Bool {
        get { return _isReady}
        set { update(key: "isReady") {
            self._isReady = newValue
            }}
    }
    private var _isExecuting: Bool
    public override var isExecuting: Bool {
        get { return _isExecuting}
        set { update(key: "isExecuting") {
            self._isExecuting = newValue
        }}
    }
    private var _isFinished: Bool
    public override var isFinished: Bool {
        get { return _isFinished}
        set { update(key: "isFinished") {
            self._isFinished = newValue
        }}
    }
    private var _isCancelled: Bool
    public override var isCancelled: Bool {
        get { return _isCancelled}
        set { update(key: "isCancelled") {
            self._isCancelled = newValue
        }}
    }
    
    override init() {
        _isReady = true
        _isExecuting = false
        _isCancelled = false
        _isFinished = false
        super.init()
        name = "Network Operation"
    }
    
    private func update(key: String, change: (()->())) {
        willChangeValue(forKey: key)
        change()
        didChangeValue(forKey: key)
    }
    
    public override var isAsynchronous: Bool {
        return true
    }
    
    public override func start() {
        if self.isExecuting == false {
            self.isReady = false
            self.isExecuting = true
            self.isFinished = false
            self.isCancelled = false
            print("\(self.name!) operation started.")
        }
    }
    
    /// Used only by subclasses. Externally you should use `cancel`.
    func finish() {
        print("\(self.name!) operation finished.")
        self.isExecuting = false
        self.isFinished = true
    }
    
    public override func cancel() {
        print("\(self.name!) operation cancelled.")
        self.isExecuting = false
        self.isCancelled = true
    }
}
