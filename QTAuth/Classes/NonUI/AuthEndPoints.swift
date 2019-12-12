//
//  AuthEndPoints.swift
//  QTAuth
//
//  Created by Maulik Sharma on 09/12/19.
//

import Foundation

enum AuthEndPoints {
    
    case signIn(email: String, password: String)
    case signUp(email: String, password: String, name: String)
    case socialLogin(platform: String, token: String)
    case emailVerification(email: String)
    case verifyOTP(id: Int, otp: Int)
    case resetPassword(id: Int, otp: Int, password: String)
    case forgotPassword(email: String)
    case signOut
    
}

extension AuthEndPoints: EndPointType {
    
    var baseURL: URL {
        switch self {
        default:
            guard let url = URL(string: authConfig.emailAuthBaseUrl ?? "") else { fatalError("baseURL could not be configured.")}
            return url
        }
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/api/member/login"
        case .signUp:
            return "/api/member"
        case let .socialLogin(platform, _):
            return "/api/login/\(platform)"
        case .emailVerification:
            return "/v1/members/verification-email"
        case let .verifyOTP(id, _):
            return "/api/v1/members/\(id)"
        case let .resetPassword(id, _, _):
            return "/api/v1/members/\(id)"
        case .forgotPassword:
            return "/api/member/forgot-password"
        case .signOut:
            return "/api/logout"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .signIn, .signUp, .socialLogin, .emailVerification, .forgotPassword:
            return .post
        case .verifyOTP, .resetPassword:
            return .patch
        case .signOut:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case let .signIn(email, password):
            let bodyParameters: [String: Any] = [
                "email": email,
                "password": password
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: nil)
            
        case let .signUp(email, password, name):
            let bodyParameters: [String: Any] = [
                "name": name,
                "email": email,
                "username": email,
                "password": password,
                "dont-login": true,
                "send-welcome-email-delay": 0
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: nil)
            
        case let .socialLogin(_, token):
            let bodyParameters: [String: Any] = [
                "token": ["access-token": token],
                "set-session": true
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: nil)
        
        case let .emailVerification(email):
            let bodyParameters: [String: Any] = [
                "member": ["email": email]
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: nil)
            
        case let .verifyOTP(_, otp):
            let bodyParameters: [String: Any] = [
                "otp": otp,
                "login": true,
                "member": ["verification-status": "email"]
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: nil)
        
        case let .resetPassword(_, otp, password):
            let bodyParameters: [String: Any] = [
                "otp": otp,
                "login": true,
                "member": ["password": password]
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: nil)
            
        case let .forgotPassword(email):
            let bodyParameters: [String: Any] = ["email": email]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: nil)
        
        case .signOut:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            return ["X-QT-AUTH": "dummy-auth"]
        }
    }
    
    // TODO: Have to retrieve this from headers of login response. Have to send it with any profile update request, might have to send it with ResetPassword also, check Verification status on login/signup response and go to OTP if null.
    
    
}
