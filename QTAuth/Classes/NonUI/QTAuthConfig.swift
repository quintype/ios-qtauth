//
//  QTAuthConfig.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 18/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import Foundation
import UIKit

public enum QTAuthProvider {
    case facebook
    case google
    case twitter
    case linkedin
    case email
    
    var logo: UIImage? {
        switch self {
        case .facebook:
            return UIImage(named: "Facebook")
        case .google:
            return UIImage(named: "Google")
        case .twitter:
            return UIImage(named: "Twitter")
        case .linkedin:
                return UIImage(named: "LinkedIn")
        case .email:
            return UIImage(named: "Email")
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .facebook:
            return "Log-in with Facebook"
        case .google:
            return "Log-in with Google"
        case .twitter:
            return "Log-in with Twitter"
        case .linkedin:
            return "Log-in with Linked-in"
        case .email:
            return "Log-in with Email"
        }
    }
}

public enum QTAuthFeture {
    
    case signup
    case forgotPassword
    case phoneAuth
    case resetPassword
}

public enum QTAuthError: Error {
    
}

public struct QTAuthUIConfig {
    public let authProviders: [QTAuthProvider]?
    public let logoImage: UIImage?
    public let features: [QTAuthFeture]?
    public let primaryColor: UIColor?
    public let secondaryColor: UIColor?
    public let primaryFont: UIFont?
    public let secondaryFont: UIFont?

    public let didFinishSignin: ((Any?, QTAuthError?) -> Void)?
    public let didFinishSignup: ((Any?, QTAuthError?) -> Void)?
    public let didResetPassword: ((Any?, QTAuthError?) -> Void)?
    public let didSendResetPasswordLink: ((Any?, QTAuthError?) -> Void)?
}
