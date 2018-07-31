//
//  MultiPlayerViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 08/06/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import Alamofire
class MultiPlayerViewController: UIViewController {

    @IBAction func button1Tapped(_ sender: UIButton) {
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
    
    @IBAction func button2Tapped(_ sender: UIButton) {
//        if let room = roomID {
//            Socket_API.sharedInstance.downloadSongsEvent(roomId: room)
//        }

        if let audioUrl = URL(string: "http://freetone.org/ring/stan/iPhone_5-Alarm.mp3") {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }
//        if let encodedString = encodedString, let data = Data(base64Encoded: encodedString) {
//            let player = try? AVAudioPlayer(data: data)
//            player?.prepareToPlay()
//            player?.play()
//        }
        
    }
    
    @IBAction func button3Tapped(_ sender: UIButton) {
//        if let room = roomID {
////            Socket_API.sharedInstance.readyToGameEvent(roomId: room)
//        }
    }
    
    @IBAction func button4Tapped(_ sender: UIButton) {
//        Socket_API.sharedInstance.startGameEvent()
    }
    
    private var roomID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        Socket_API.sharedInstance.delegate = self
//        Socket_API.sharedInstance.createGameResponseEvent()
//        Socket_API.sharedInstance.readyToGameResponseEvent()
//        Socket_API.sharedInstance.startGameResponseEvent()
//        Socket_API.sharedInstance.downloadSongsResponseEvent()
        // Do any additional setup after loading the view.
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
