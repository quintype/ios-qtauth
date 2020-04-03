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
    case resetPassword(email: String)
    case fetchMemberInfo(xQTAuth: String)
    case updateMemberMetadata(metadata: MemberMetadata, xQTAuth: String)
    case changePassword(id: Int, otp: Int, password: String, xQTAuth: String)
    case imageSignIn(fileName: String, imageType: String)
    case signOut(xQTAuth: String)
    case memberProfile(tempS3key: String, userName: String, xQTAuth: String)
    
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
            return "/api/v1/members/verification-email"
        case let .verifyOTP(id, _):
            return "/api/v1/members/\(id)"
        case let .changePassword(id, _, _, _):
            return "/api/v1/members/\(id)"
        case .resetPassword:
            return "/api/member/forgot-password"
        case .fetchMemberInfo:
            return "/api/v1/members/me"
        case .updateMemberMetadata:
            return "/api/member/metadata"
        case .signOut:
            return "/api/logout"
        case .imageSignIn:
            return "/api/sign"
        case .memberProfile:
            return "/api/v1/members/profile"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .signIn, .signUp, .socialLogin, .emailVerification, .updateMemberMetadata, .resetPassword:
            return .post
        case .verifyOTP, .changePassword:
            return .patch
        case .signOut, .fetchMemberInfo:
            return .get
        case .imageSignIn:
            return .get
        case .memberProfile:
            return .patch
        }
    }
    
    var task: HTTPTask {
        switch self {
        case let .signIn(email, password):
            let bodyParameters: [String: Any] = [
                "email": email,
                "password": password
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["x-qt-auth": "dummy"])
            
        case let .signUp(email, password, name):
            let bodyParameters: [String: Any] = [
                "name": name,
                "email": email,
                "username": email,
                "password": password,
                "dont-login": true,
                "send-welcome-email-delay": 0
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["x-qt-auth": "dummy"])
            
        case let .socialLogin(_, token):
            let bodyParameters: [String: Any] = [
                "token": ["access-token": token],
                "set-session": true
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["x-qt-auth": "dummy"])
            
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
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["x-qt-auth": "dummy"])
            
        case let .resetPassword(email):
            let bodyParameters: [String: Any] = ["email": email]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: nil)
            
        case let .changePassword(_, otp, password, xQTAuth):
            let bodyParameters: [String: Any] = [
                "otp": otp,
                "login": true,
                "member": ["password": password]
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["x-qt-auth": xQTAuth])
            
        case let .updateMemberMetadata(metadata, xQTAuth):
            let bodyParameters: [String: Any] = [
                "metadata": metadata.encodedToDictionary ?? [:]
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["x-qt-auth": xQTAuth])
            
        case let .fetchMemberInfo(xQTAuth):
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["x-qt-auth": xQTAuth])
            
        case let .signOut(xQTAuth):
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["x-qt-auth": xQTAuth])
        case let .imageSignIn(fileName, fileType):
            let bodyParameters: [String: Any] = ["file-name": fileName , "mime-type": fileType]
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: bodyParameters, additionHeaders: nil)
        case let .memberProfile(tempS3key, userName, xQTAuth):
            let bodyParameters: [String: Any] = [
                "temp-s3-key": tempS3key,
                "name": userName
            ]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["x-qt-auth": xQTAuth])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
        /*
         switch self {
         case let .fetchMemberInfo(xQTAuth):
         return ["x-qt-auth": xQTAuth]
         case let .updateMemberMetadata(_, xQTAuth):
         return ["x-qt-auth": xQTAuth]
         case let .changePassword(_, _, _, xQTAuth):
         return ["x-qt-auth": xQTAuth]
         default:
         return ["x-qt-auth": "dummy"]
         }
         */
    }
    
}
