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
    
    public init(levelId: Int, service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        request = LevelInfoRequest(id: levelId)
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
        } catch let error {
            print("Error of parsing \(error)")

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
        //        self.failure?(error)
        self.finish()
    }
}
