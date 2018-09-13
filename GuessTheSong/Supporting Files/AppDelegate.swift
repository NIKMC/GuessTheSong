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
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let api = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
        print("The baseURL is \(api)")
        BackendConfiguration.shared = BackendConfiguration(baseURL: URL(string: api)!)
        GIDSignIn.sharedInstance().clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as! String
        GIDSignIn.sharedInstance().delegate = self
        
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
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication: sourceApplication,
                                          annotation: annotation)
        return handled
    }
    // [END openurl]
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                          annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }

    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
//        if let error = error {
//            print("\(error.localizedDescription)")
//            // [START_EXCLUDE silent]
//            NotificationCenter.default.post(
//                name: .googleSignInNotification, object: nil, userInfo: nil)
//            // [END_EXCLUDE]
//        } else {
//            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let accessToken = user.authentication.accessToken
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//            print("The result in appDelegate)")
//            print("userID \(String(describing: userId))")
//            print("idToken \(String(describing: idToken))")
//            print("accessToken \(String(describing: accessToken))")
//            print("fullName \(String(describing: fullName))")
//            print("givenName \(String(describing: givenName))")
//            print("familyName \(String(describing: familyName))")
//            print("email \(String(describing: email))")
//
//            // [START_EXCLUDE]
//            NotificationCenter.default.post(
//                name: .googleSignInNotification,
//                object: user,
//                userInfo: ["userID": "userID \(String(describing: userId))"])
//            // [END_EXCLUDE]
//        }
    }
    // [END signin_handler]
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // [START_EXCLUDE]
//        NotificationCenter.default.post(
//            name: .googleSignInNotification,
//            object: nil,
//            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    // [END disconnect_handler]
    
}

