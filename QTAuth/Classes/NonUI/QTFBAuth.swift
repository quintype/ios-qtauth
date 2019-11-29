//
//  QTFBAuth.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 23/10/19.
//

import Foundation
import UIKit
import FBSDKLoginKit

class QTFBAuth {
    
    private weak var viewController: QTViewController?
    
    required init(vc: QTViewController) {
        viewController = vc
    }
    
    func fbLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions:["public_profile"],
                           from: viewController,
                           handler: { (response: LoginManagerLoginResult!, error: NSError!) in
                            if(error == nil){
                                QTAuth.instance.didFinishSignin(QTAuthProvider.facebook, nil)
                            } else {
                                QTAuth.instance.didFinishSignin(nil, .authFailed)
                            }
        } as? LoginManagerLoginResultBlock)
    }
}
