//
//  QTGAuth.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 23/10/19.
//

import Foundation
import UIKit
import GoogleSignIn

class QTGAuth: NSObject, GIDSignInDelegate {
    
    required init(vc: QTViewController) {
        super.init()
        GIDSignIn.sharedInstance()?.presentingViewController = vc
        GIDSignIn.sharedInstance().clientID = authConfig.googleClientId
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func signin() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
            QTAuth.instance.didFinishSignin(nil, .authFailed)
          return
        }
        // Perform any operations on signed in user here.
//        let userId = user.userID                  // For client-side use only!
//        let idToken = user.authentication.idToken // Safe to send to the server
//        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email
        
        QTAuth.instance.didFinishSignin(user.userID, nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}
