

//
//  ResponseMessage.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 30/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

struct ResponseMessage: Codable {
    var err: Bool
    var msg: String?
    var token: String?
}
