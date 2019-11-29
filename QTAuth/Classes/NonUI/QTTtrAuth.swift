//
//  QTtrAuth.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 24/10/19.
//

import Foundation
import TwitterKit

class QTTtrAuth {
    
    var viewController: QTViewController!
    
    init(vc: QTViewController) {
      viewController = vc
      configure()
    }
    
    func configure() {
        TWTRTwitter.sharedInstance().start(withConsumerKey: authConfig.twitterKeys?.apiKey ?? "",
                                           consumerSecret:authConfig.twitterKeys?.sec ?? "")
    }
    
    func login() {
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if error == nil {
                QTAuth.instance.didFinishSignin(session?.userID, nil)
            } else {
                QTAuth.instance.didFinishSignin(nil, error as? QTAuthError)
            }
        }
    }
}
