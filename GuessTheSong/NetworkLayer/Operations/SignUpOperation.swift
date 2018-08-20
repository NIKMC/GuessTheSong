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
    
        public var success: ((SignUpResponse) -> Void)?
        public var failure: ((NSError) -> Void)?
    
    public init(email: String, login username: String, password: String, passwordRep: String, service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        request = SignUpRequest(email: email, login: username, password: password, first_name: username, last_name: username)
        super.init(service: service)
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    private func handleSuccess(_ response: Data) {
        do {
            let data = try JSONDecoder().decode(SignUpResponse.self, from: response)
            print("The response is: \(String(describing: data))")
            self.success?(data)
            self.finish()

        } catch let error {
            print("Error of parsing \(error)")
            handleFailure(error as NSError)
        }
        
//        do {
//            //            let item = try SignInResponseMapper.process(response)
//            //            self.success?(item)
//            self.finish()
//        } catch {
//            //            handleFailure(NSError.cannotParseResponse())
//        }
    }
    
    private func handleFailure(_ error: NSError) {
        self.failure?(error)
        self.finish()
    }
}
