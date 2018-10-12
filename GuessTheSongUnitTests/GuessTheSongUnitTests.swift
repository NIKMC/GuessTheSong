//
//  GuessTheSongUnitTests.swift
//  GuessTheSongUnitTests
//
//  Created by Ivan Nikitin on 16/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import XCTest
@testable import GuessTheSong

class GuessTheSongUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        NetworkQueue.shared = NetworkQueue()
    }
    
    func test1JoinMulti() {
        let expectedResult = expectation(description: "Async request")
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNTM3MTE4MDM2LCJlbWFpbCI6ImFkbWluQG15cHJvamVjdC5jb20ifQ.Fiaslci5VnjUtsoBHkp83F5ChKy_crGEz0nQ1nb2q54"
        let operation = MultiPlayerJoinOperation(token: token)
        
        //        operation.start()
        
        operation.success = { (response) in
            print("socket url is \(response.websocket_url)")
            print("socket url is \(response.game.songs)")
            //            Session.shared.ssid = ssid_token
            XCTAssertNotNil(response.websocket_url)
            
            expectedResult.fulfill()
        }
        
        operation.failure = { (error) in
            print("Error of get ssid is \(error)")
            XCTAssert(false, "fail request get ssid")
            expectedResult.fulfill()
        }
        
        NetworkQueue.shared.addOperation(operation)
        
        waitForExpectations(timeout: 80, handler:nil)
    }
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
