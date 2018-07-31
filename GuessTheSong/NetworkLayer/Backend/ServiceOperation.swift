//
//  ServiceOperation.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 27/06/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class ServiceOperation: NetworkOperation {
    
    let service: BackendService
    
    init(service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        self.service = service
        super.init()
    }
    
    override public func cancel() {
        service.cancel()
        super.cancel()
    }
}
