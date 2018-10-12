//
//  SignInOperation.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 19/07/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class SignInOperation: ServiceOperation {
    
    private let request: SignInRequest
    
    public var success: (() -> ())?
    public var failure: ((NSError) -> ())?
    
    public init(username: String, password: String, service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        request = SignInRequest(login: username, password: password)
        super.init(service: service)
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    private func handleSuccess(_ response: Data) {
        do {
            let data = try JSONDecoder().decode(SignInResponse.self, from: response)
                        print("The response of SignIn is: \(String(describing: data.token))")
            Session.shared.access_token = data.token
            self.success?()
            self.finish()
        } catch let error {
            print("Error of parsing \(error)")
            handleFailure(error as NSError)
        }
    }
    
    private func handleFailure(_ error: NSError) {
        self.failure?(error)
        self.finish()
    }
}
