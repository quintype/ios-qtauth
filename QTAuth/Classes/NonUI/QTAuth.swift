//
//  QTAuth.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 21/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit
import LinkedinSwift

//MARK: Global
var bundle: Bundle!
var authConfig: QTAuthUIConfig!
let xqtAuthKey = "X-QT-AUTH"

func getAppImage(with name: String) -> UIImage? {
    return UIImage(named: name, in: Bundle.main, compatibleWith: nil)
}

public class QTAuth {
    public static let instance: QTAuth = QTAuth()
    public var didFinishSignin: ((Any?, QTAuthError?) -> Void) = {_, _ in}
    public var didFinishSignup: ((Any?, QTAuthError?) -> Void) = {_, _ in}
    public var didResetPassword: ((Any?, QTAuthError?) -> Void) = {_, _ in}
    public var didSendResetPasswordLink: ((Any?, QTAuthError?) -> Void) = {_, _ in}
    
    private var application: UIApplication!
    
    private init() {
        let tempBundle = Bundle(for: QTAuth.self)
        bundle = Bundle(url: tempBundle.url(forResource: "QTAuth", withExtension: "bundle")!)!
    }
    
    public func initialize(with config: QTAuthUIConfig) {
        authConfig = config
    }
    
    public func initialize(with configName: String) throws {
        guard let path = Bundle.main.path(forResource: configName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let decoded = try? JSONDecoder().decode(QTAuthUIConfig.self, from: data) else {
                throw QTAuthError.invalidConfig
        }
    
        authConfig = decoded
    }
    
    public var rootController: UIViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "QTAuth", bundle: bundle)
        let rootController = storyBoard.instantiateViewController(withIdentifier: "QTLoginViewController")
        return rootController
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.absoluteString.contains("facebook") {
            return facebookOpen(app, open: url, options: options)
        } else if url.absoluteString.contains("google") {
            return handleGoogleSignin(url: url)
        } else if url.absoluteString.contains("twitter") {
            return twitterOpen(app, open: url, options: options)
        } else if LinkedinSwiftHelper.shouldHandle(url) {
            return linkedInOpen(app, open: url, options: options)
        }
        return false
    }
}

//MARK: FaceBook
extension QTAuth {
    public func configFacebookAuth(with  application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        self.application = application
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
      
    func facebookOpen(url: URL, sourceApplication: String, anotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application,
                                                      open: url,
                                                      sourceApplication: sourceApplication,
                                                      annotation: anotation)
    }
      
    func facebookOpen(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return QTAuth.instance.facebookOpen(url: url,
                                            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String,
                                            anotation: options[UIApplication.OpenURLOptionsKey.annotation] as Any)
    }
}

//MARK: GoogleSignIn
extension QTAuth {
    public func handleGoogleSignin(url: URL) -> Bool{
        return GIDSignIn.sharedInstance().handle(url)
    }
}

//MARK: Twitter Sign-in
extension QTAuth {
    public func twitterOpen(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
}

//MARK: Linked-in Sign-in
extension QTAuth {
    public func linkedInOpen(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApp =  options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        let anotation = options[UIApplication.OpenURLOptionsKey.annotation]
        return LinkedinSwiftHelper.application(app, open: url, sourceApplication: sourceApp, annotation: anotation)
    }
}
