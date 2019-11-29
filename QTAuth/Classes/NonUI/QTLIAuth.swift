//
//  QTLIAuth.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 24/10/19.
//

import Foundation
import LinkedinSwift

class QTLIAuth {
    
    var viewController: QTViewController!
    
    var liHelper: LinkedinSwiftHelper!
    
    init(vc: QTViewController) {
        viewController = vc
        configure()
    }
       
    func configure() {
        let apiKey = authConfig.linkedInKeys?.apiKey ?? ""
        let sec = authConfig.linkedInKeys?.sec ?? ""
        guard let config = LinkedinSwiftConfiguration(clientId: apiKey,
                                                clientSecret: sec,
                                                state: "quintype.auth",
                                                permissions: ["r_basicprofile", "r_emailaddress"],
                                                redirectUrl: "http://www.google.com") else {
                                                    return
        }
        liHelper = LinkedinSwiftHelper(configuration: config, nativeAppChecker: WebLoginOnly())
    }
    
    func login() {
        liHelper.authorizeSuccess({ (lsToken) -> Void in
            QTAuth.instance.didFinishSignin(lsToken, nil)
        }, error: { (error) -> Void in
            QTAuth.instance.didFinishSignin(nil, error as? QTAuthError)
        }, cancel: { () -> Void in
            QTAuth.instance.didFinishSignin(nil, QTAuthError.authCanceled)
        })
    }
}

