//
//  BackendConfiguration.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 27/06/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
public final class BackendConfiguration {
    
    let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public static var shared: BackendConfiguration!
}
