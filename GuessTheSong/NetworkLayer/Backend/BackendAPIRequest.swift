//
//  BackendAPIRequest.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 26/06/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public protocol BackendAPIRequest {
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPQuery { get }
    var parameters: [String: String]? { get }
    var headers: [String: String]? { get }
}

extension BackendAPIRequest {
    func defaultJSONHeader() -> [String:String] {
        return ["Content-Type": "application/json"]
    }
}
