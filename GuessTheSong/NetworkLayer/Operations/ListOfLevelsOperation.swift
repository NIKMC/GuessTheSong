//
//  ListOfLevelsOperation.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 16/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation


public class ListOfLevelsOperation: ServiceOperation {
    
    private let request: ListOfLevelsRequest
    
    public var success: (([GameResponse]) -> Void)?
    public var failure: ((NSError) -> Void)?
    
    public init(token: String, service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        request = ListOfLevelsRequest(token: token)
        super.init(service: service)
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    private func handleSuccess(_ response: Any?) {
        do {
            let data = try JSONDecoder().decode(GamesResponse.self, from: response as! Data)
            print("The response of ProfileInfoOperation is: \(String(describing: data))")
            self.success?(data.results)
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
