//
//RemindMe : AppDelegate.swift By: Tymon Golęba Frygies on 17:41. 
// Copyright (c) 2020, Tymon Golęba Frygies. All rights reserved.


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    // triggered when app gets loaded up
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    // triggered when something happens to the phone (a call) while app is launched
    func applicationWillResignActive(_ application: UIApplication) {
        //
    }

    //kicks in when app is moved from the first app into the background
    func applicationDidEnterBackground(_ application: UIApplication) {
        //
    }

    // when app gets terminated (by user or when phone claims resources)
    func applicationWillTerminate(_ application: UIApplication) {
        //
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

