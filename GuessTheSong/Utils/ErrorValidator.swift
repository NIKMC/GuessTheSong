//
//  ErrorValidator.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 26/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class ErrorValidator {
    
    internal var typeCode: Int?
    internal var operation: ServiceOperation?
    
    
    func chooseActionAfterResponse(errorResponse: NSError, success: (()->())?, failure: ((NSError)->())?) {
        let code = errorResponse.code
        switch code {
        case 401:
            operation = SignInOperation(username: Session.shared.username!, password: Session.shared.password!)
            let request = operation as? SignInOperation
            request?.start()
            request?.success = {
                success?()
            }
            request?.failure = { [weak self] (error) in
                self?.chooseActionAfterResponse(errorResponse: error, success: success, failure: failure)
            }
        default:
            print("default case has been worked \(errorResponse.localizedDescription)")
            failure?(errorResponse)
        }
        return
    }
    
}
