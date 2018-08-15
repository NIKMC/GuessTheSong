//
//  ProfileInfoOperation.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 06/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation


public class ProfileInfoOperation: ServiceOperation {
    
    private let request: ProfileRequest
    
        public var success: ((UserProfile) -> Void)?
        public var failure: ((NSError) -> Void)?
    
    public init(token: String, id: String, service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        request = ProfileRequest(token: token, userId: id)
        super.init(service: service)
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    private func handleSuccess(_ response: Any?) {
        do {
            let data = try JSONDecoder().decode(UserProfile.self, from: response as! Data)
            //            print("The response is: \(String(describing: data.response))")
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
