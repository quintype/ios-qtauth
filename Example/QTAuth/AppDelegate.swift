//
//  AppDelegate.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 10/22/2019.
//  Copyright (c) 2019 Benoy Vijayan. All rights reserved.
//

import UIKit
import QTAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        
        do{
            try QTAuth.instance.initialize(with: "QTAuthConfig")
            window?.rootViewController = QTAuth.instance.rootController
        } catch {
            
            let providers: [QTAuthProvider] = [.facebook, .google, .twitter, .linkedIn, .email]
                   let logo = UIImage(named: "Logo")
            let googleClientId = "1049117273259-ogje0ol9nf6k3up3fbvjh9b814atp1pb.apps.googleusercontent.com"

            let twitterKeys = Credential(apiKey: "djmfdO25cM4xjbBIbjuwfQ8pr", sec: "mbdDyFjffX3RE2DL2af5I3mn79rEOQljrdKGV9y9hAEROGxap3")
                

            let liKeys = Credential(apiKey: "81p81utz045o5m", sec: "14d8eabelh7bLcS3")

            let config = QTAuthUIConfig(authProviders: providers,
                                        logo: "Logo",
                                        googleClientId: googleClientId,
                                        twitterKeys: twitterKeys,
                                        linkedInKeys: liKeys)

            QTAuth.instance.initialize(with: config)
           

            
        }
        
         QTAuth.instance.configFacebookAuth(with: application, launchOptions: launchOptions)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return QTAuth.instance.application(app, open: url, options: options)
    }
}

