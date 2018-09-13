//
//  FinishGameResponse.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 04/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class FinishGameResponse: Codable {
    
    var message: String
    var experience: Int
    
    
    init(message: String, experience: Int) {
        self.message = message
        self.experience = experience
    }
    
    //FIXME: - Error of parsing keyNotFound(CodingKeys(stringValue: "experience", intValue: nil), Swift.DecodingError.Context(codingPath: [], debugDescription: "No value associated with key CodingKeys(stringValue: \"experience\", intValue: nil) (\"experience\").", underlyingError: nil))
//    error of loading indfo about level Error Domain=NSCocoaErrorDomain Code=4865 "No value associated with key CodingKeys(stringValue: "experience", intValue: nil) ("experience")." UserInfo={NSCodingPath=(
//    ), NSDebugDescription=No value associated with key CodingKeys(stringValue: "experience", intValue: nil) ("experience").}

}
