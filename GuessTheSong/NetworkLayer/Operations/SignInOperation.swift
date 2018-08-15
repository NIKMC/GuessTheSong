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
    
    public var success: ((String) -> Void)?
    public var failure: ((NSError) -> Void)?
    
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
                        print("The response is: \(String(describing: data.token))")
            success?(data.token)
        } catch let error {
            print("Error of parsing \(error)")

        }
        self.finish()
        
//        do {
////            let item = try SignInResponseMapper.process(response)
////            self.success?(item)
//
//        } catch {
////            handleFailure(NSError.cannotParseResponse())
//        }
    }
    
    private func handleFailure(_ error: NSError) {
        self.failure?(error)
        self.finish()
    }
}
