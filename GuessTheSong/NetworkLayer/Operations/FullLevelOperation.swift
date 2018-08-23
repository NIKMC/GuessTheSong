//
//  FullLevelOperation.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 07/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class FullLevelOperation: ServiceOperation {
    
    private let request: LevelInfoRequest
    
    public var success: ((LevelResponse) -> Void)?
    public var failure: ((NSError) -> Void)?
    
    public init(token: String, levelId: Int, service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        request = LevelInfoRequest(token: token, id: levelId)
        super.init(service: service)
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    private func handleSuccess(_ response: Any?) {
        do {
            let data = try JSONDecoder().decode(LevelResponse.self, from: response as! Data)
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
