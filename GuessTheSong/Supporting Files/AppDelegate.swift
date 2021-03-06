//
//  AppDelegate.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 21/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let api = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
        print("The baseURL is \(api)")
        BackendConfiguration.shared = BackendConfiguration(baseURL: URL(string: api)!)
        GIDSignIn.sharedInstance().clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as! String
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        Socket_API.sharedInstance.disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        Socket_API.sharedInstance.connect(connection: .User)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func switchRootViewController(nameStoryBoard: String, idViewController: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: nameStoryBoard, bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: idViewController)
        self.window?.rootViewController = nav
        return nav
    }

    // [START openurl]
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication: sourceApplication,
                                          annotation: annotation)
        return true
    }
    // [END openurl]
    
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
//        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//
//        GIDSignIn.sharedInstance().handle(url,
//                                          sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
//                                          annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//
//        return true
//    }
    
}

