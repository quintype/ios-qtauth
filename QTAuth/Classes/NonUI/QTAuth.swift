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
import FacebookLogin
import GoogleSignIn
import TwitterKit

//MARK: Global
var bundle: Bundle!
var authConfig: QTAuthConfig! {
    didSet {
        GIDSignIn.sharedInstance().clientID = authConfig.googleClientId
    }
}
let xqtAuthKey = "x-qt-auth"

func getAppImage(with name: String) -> UIImage? {
    return UIImage(named: name, in: Bundle.main, compatibleWith: nil)
}

public class QTAuth {
    public static let instance: QTAuth = QTAuth()
    public let apiManager =  AuthAPIManager()
    public var didFinishSignin: ((Any?, QTAuthError?) -> Void) = {_, _ in}
    public var didFinishSignup: ((Any?, QTAuthError?) -> Void) = {_, _ in}
    public var didResetPassword: ((Any?, QTAuthError?) -> Void) = {_, _ in}
    public var didSendResetPasswordLink: ((Any?, QTAuthError?) -> Void) = {_, _ in}
    
    private var application: UIApplication!
    public static var termsOfServiceUrl: String?
    public static var privacyPolicyUrl: String?
    
    private init() {
        let tempBundle = Bundle(for: QTAuth.self)
        bundle = Bundle(url: tempBundle.url(forResource: "QTAuth", withExtension: "bundle")!)!
    }
    
    public func initialize(with config: QTAuthConfig) {
        authConfig = config
    }
    
    public func initialize(with configName: String) throws {
        guard let path = Bundle.main.path(forResource: configName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let decoded = try? JSONDecoder().decode(QTAuthConfig.self, from: data) else {
                throw QTAuthError.invalidConfig
        }
        authConfig = decoded
    }
    public var rootController: UIViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "QTAuth", bundle: bundle)
        let viewControllerIdentifier = signedInMemberInfo != nil ? "MyProfileViewController" : "SignInViewController"
        let rootController = storyBoard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        return rootController
    }
    public var signedInMemberInfo: MemberResponse? {
        get {
            guard let data = UserDefaults.standard.object(forKey: "MemberInfo") as? Data else { return nil }
            guard let info = try? JSONDecoder().decode(MemberResponse.self, from: data) else { return nil }
            guard info.xQTAuth != nil, info.member?.verificationStatus != nil else { return nil }
            return info
        }
        set {
            if let info = newValue {
                guard info.xQTAuth != nil, info.member?.verificationStatus != nil else { return }
                guard let jsonData = try? JSONEncoder().encode(info) else { return }
                UserDefaults.standard.set(jsonData, forKey: "MemberInfo")
                print("Saving new signedInMemberInfo: " + String(describing: newValue))
            } else { // Signing out
                UserDefaults.standard.removeObject(forKey: "MemberInfo")
                print("Removed signedInMemberInfo")
            }
        }
    }
    public var isProfilePicUpdate: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "ProfilePicUpdate")
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "ProfilePicUpdate")
            } else {
                 UserDefaults.standard.removeObject(forKey: "ProfilePicUpdate")
            }
        }
    }
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.absoluteString.contains("facebook") {
            return facebookOpen(app, open: url, options: options)
        } else if url.absoluteString.contains("google") {
            return handleGoogleSignin(url: url)
        } else if url.absoluteString.contains("twitter") {
            return twitterOpen(app, open: url, options: options)
        }
        return false
    }
}

//MARK: FaceBook
extension QTAuth {
    public func configFacebookAuth(with application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.application = application
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
      
    func facebookOpen(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(application,
                                                      open: url,
                                                      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                      annotation: options[UIApplication.OpenURLOptionsKey.annotation] as Any)
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
