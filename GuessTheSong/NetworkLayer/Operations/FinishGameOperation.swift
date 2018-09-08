//
//  FinishGameOperation.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 04/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class FinishGameOperation: ServiceOperation {
    
    private let request: FinishGameRequest
    
    public var success: ((FinishGameResponse) -> Void)?
    public var failure: ((NSError) -> Void)?
    
    public init(token: String, gameId: Int, time timeOfPlaying: Int, service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        request = FinishGameRequest(token: token, id: gameId, time: timeOfPlaying)
        super.init(service: service)
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    private func handleSuccess(_ response: Any?) {
        do {
            let data = try JSONDecoder().decode(FinishGameResponse.self, from: response as! Data)
            print("The response is: \(String(describing: data))")
            success?(data)
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
