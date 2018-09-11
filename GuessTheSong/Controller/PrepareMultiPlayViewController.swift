//
//  MultiPlayerViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 08/06/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import Alamofire
import SocketIO

import Starscream


class PrepareMultiPlayViewController: UIViewController, WebSocketDelegate {
  
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("got some text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }
    

    var socket: WebSocket!
    
    
    @IBAction func button1Tapped(_ sender: UIButton) {
        let urlString = "ws://430408be.ngrok.io/game/4/?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNTM2NDQ5MDQyLCJlbWFpbCI6ImFzZGFzZEBhc2Rhc2QucnUifQ.1o_Xp5XM72aAkj31RGbJEmmxim6Rx7vbyqlRrnfcPnQ"
        var request = URLRequest(url: URL(string: urlString)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
        
        
//        Socket_API.sharedInstance.createGameEvent(id: "5a252ef224c6b30979198ca3")
        
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent("pig.png")
//
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
        
//        Alamofire.download(urlString, to: destination).response { response in
//            print(response)
//            
//            if response.error == nil, let imagePath = response.destinationURL?.path {
//                let image = UIImage(contentsOfFile: imagePath)
//            }
//        }
        
        
        
    }
    
    
   
    
    private var roomID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(self.back(sender:)))
//        Socket_API.sharedInstance.delegate = self
//        Socket_API.sharedInstance.createGameResponseEvent()
//        Socket_API.sharedInstance.readyToGameResponseEvent()
//        Socket_API.sharedInstance.startGameResponseEvent()
//        Socket_API.sharedInstance.downloadSongsResponseEvent()
        // Do any additional setup after loading the view.
    }
    
    @objc func back(sender: AnyObject) {
        guard(navigationController?.popViewController(animated: true)) != nil
            else {
                print("No view controllers to pop off")
                return
        }
    }
}

//extension MultiPlayerViewController: ResponseGameDelegate {
//    func createGameResult(roomId: String) {
//        print("createGameResult \(roomId)")
//        roomID = roomId
//    }
//
//    func downloadSongsResult() {
//        print("downloadSongsResult ")
//    }
//
//    func readyToGameResult(result: String) {
//        print("readyToGameResult \(result)")
//    }
//
//    func startGame(action: String) {
//        print("startGame delegate \(action)")
//
//    }
//
//    func success() {
//
//    }
//
//    func printErrorMessage(error: String?) {
//
//    }
//
//    func informDisconnectedMessage() {
//
//    }
//
//    func informErrorMessage(error: String) {
//
//    }
//
//
//}
