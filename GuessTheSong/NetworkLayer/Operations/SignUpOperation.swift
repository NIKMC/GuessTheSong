//
//  SignUpOperation.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 20/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class SignUpOperation: ServiceOperation {
    
    private let request: SignUpRequest
    
    //    public var success: ((SignInItem) -> Void)?
    //    public var failure: ((NSError) -> Void)?
    
    public init(email: String, login: String, password: String, passwordRep: String, service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        request = SignUpRequest(email: email, login: login, password: password, passwordRep: passwordRep)
        super.init(service: service)
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    private func handleSuccess(_ response: Any?) {
        //        do {
        //            let data = try JSONDecoder().decode(Response.self, from: response)
        //            //            print("The response is: \(String(describing: data.response))")
        //            success?(data.response)
        //        } catch let error {
        //            print("Error of parsing \(error)")
        //
        //        }
        
        
        do {
            //            let item = try SignInResponseMapper.process(response)
            //            self.success?(item)
            self.finish()
        } catch {
            //            handleFailure(NSError.cannotParseResponse())
        }
    }
    
    private func handleFailure(_ error: NSError) {
        //        self.failure?(error)
        self.finish()
    }
}
