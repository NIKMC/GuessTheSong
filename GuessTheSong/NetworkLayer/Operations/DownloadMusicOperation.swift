//
//  DownloadMusicOperation.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 07/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

public class DownloadMusicOperation: ServiceOperation {
    
    private let request: DownloadMusicRequest
    
    public var success: ((Data) -> Void)?
    public var failure: ((NSError) -> Void)?
    
    public init(musicUrl: String, service: BackendService = NetworkBackendService(BackendConfiguration.shared)) {
        request = DownloadMusicRequest(url: musicUrl)
        super.init(service: service)
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    private func handleSuccess(_ response: Any?) {
        let data = response as! Data
        success?(data)
        
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
