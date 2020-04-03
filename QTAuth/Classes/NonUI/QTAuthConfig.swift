//
//  QTAuthConfig.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 18/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import Foundation
import UIKit
enum SegueIdentifier: String {
    case staticPageSegue = "StaticpageSegue"
    case signInEmailVerificationSegue = "SignInEmailVerificationSegue"
}
struct StaticPageUrl {
    static let privacyPolicy = QTAuth.privacyPolicyUrl ?? ""
    static let termsAndCondition = QTAuth.termsOfServiceUrl ?? ""
    
}
public enum QTAuthProvider: String, Codable {
    case facebook
    case google
    case twitter
    case email
    
    public var logo: UIImage? {
        
        switch self {
        case .facebook:
            return UIImage(named: "Facebook", in: bundle, compatibleWith: nil)
        case .google:
            return UIImage(named: "Google", in: bundle, compatibleWith: nil)
        case .twitter:
            return UIImage(named: "Twitter", in: bundle, compatibleWith: nil)
        case .email:
            return UIImage(named: "Mail", in: bundle, compatibleWith: nil)
        }
    }
    
    public var buttonTitle: String {
        switch self {
        case .facebook:
            return "Log-in with Facebook"
        case .google:
            return "Log-in with Google"
        case .twitter:
            return "Log-in with Twitter"
        case .email:
            return "Log-in with Email"
        }
    }
}

public enum QTAuthFeture: String, Codable {
    
    case signup
    case forgotPassword
    case otpAuth
    case resetPassword
}

public enum QTAuthError: Error {
    case authFailed
    case authCanceled
    case invalidConfig
    case invalidBaseUrl
    case parserError
}

public struct QTFontInfo: Codable {
    public let name: String?
    public let size: CGFloat?
    
    public init(name: String, size: CGFloat) {
        self.name = name
        self.size = size
    }
    
    var font: UIFont {
        return UIFont(name: name ?? "Helvetica", size: size ?? 17) ?? UIFont.systemFont(ofSize: 17)
    }
}

public struct Credential: Codable {
    public let apiKey: String?
    public let sec: String?
    
    public init(apiKey: String, sec: String) {
        self.apiKey = apiKey
        self.sec = sec
    }
}

public struct QTAuthConfig: Codable {
    
    //authProvideres
    public let authProviders: [QTAuthProvider]?
    public let logo: String?
    public let features: [QTAuthFeture]?
    public let primaryColor: String?
    public let secondaryColor: String?
    public let primaryFont: QTFontInfo?
    public let secondaryFont: QTFontInfo?
    
    public let googleClientId: String?
    public let twitterKeys: Credential?
    public let emailAuthBaseUrl: String?
    
    public init(authProviders: [QTAuthProvider]? = nil,
                logo: String? = "qtlogo",
                features: [QTAuthFeture]? = [.signup, .resetPassword, .forgotPassword, .otpAuth],
                primaryColor: String? = "#000000",
                secondaryColor: String? = "#000000",
                primaryFont: QTFontInfo? = QTFontInfo(name: "Helvetica", size: 17),
                secondaryFont: QTFontInfo? = QTFontInfo(name: "Helvetica", size: 14),
                googleClientId: String? = nil,
                twitterKeys: Credential? = nil,
                emailAuthBaseUrl: String? = nil) {
        
        self.authProviders = authProviders ?? [QTAuthProvider.email]
        self.logo = logo
        self.features = features
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self.googleClientId = googleClientId
        self.twitterKeys = twitterKeys
        self.emailAuthBaseUrl = emailAuthBaseUrl
    }
}
