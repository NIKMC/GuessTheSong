//
//  MultiPlayerJoinOperation.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 16/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class MultiPlayerJoinOperation: ServiceOperation {
    
    private let request: MultiPlayerRequest
    
    public var success: ((MultiPlayerResponse) -> Void)?
    public var failure: ((NSError) -> Void)?
    
    public init(token: String, service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        request = MultiPlayerRequest(token: token)
        super.init(service: service)
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    private func handleSuccess(_ response: Any?) {
        do {
            let data = try JSONDecoder().decode(MultiPlayerResponse.self, from: response as! Data)
            print("The response of ProfileInfoOperation is: \(String(describing: data))")
            self.success?(data)
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
