//
//  AppDelegate.swift
//  mylove
//
//  Created by Henok Welday on 4/17/20.
//  Copyright © 2020 Henok Welday. All rights reserved.
//

import UIKit
import Parse 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // the code bellow is for my herocku server
        let config = ParseClientConfiguration{(theConfig) in
            theConfig.applicationId = "loveiscoolapp"
            theConfig.server = "http://humanloverserver.herokuapp.com/parse"
            theConfig.clientKey = "humanloveeachother"
        }
        Parse.initialize(with: config)
        
//        parse-dashboard --dev --appId loveiscoolapp --masterKey humanloveeachother --serverURL "http://humanloverserver.herokuapp.com/parse"

        
        
        return true
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

