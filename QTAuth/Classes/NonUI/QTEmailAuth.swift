//
//  QTEmailAuth.swift
//  Pods
//
//  Created by Benoy Vijayan on 25/10/19.
//

import Foundation
import AFNetworking


enum Api: String {
    typealias RawValue = String
    
    case signIn = "/api/member/login"
    case signUp = "/api/member"
    case emailVerification = "/v1/members/verification-email"
    case forgotPassword = "/api/member/forgot-password"
    case resetPassword = "/api/member/password"
    case verifyOtp = "/api/v1/members"
    case profileInfo = "/api/v1/members/me"
    case userMetadata = "/api/member/metadata"
    case logout = "/api/logout"
    
}

class QTEmailAuth {
    
    private var httpClient = QTAuthHttpClient()
    
    func login(with email: String,
               password: String,
               callback: @escaping (Any?, Error?) -> Void) {
        
        let urlStr = (authConfig.emailAuthBaseUrl ?? "") + Api.signIn.rawValue
        let params = ["email":email, "password":password]
        httpClient.postData(with: urlStr,
                           param: params,
                           useXqtAuth: false,
                           callback: {data, error in
                            
                            guard let data = data, error == nil else {
                                callback(nil, error)
                                return
                                
                            }
                            let str = String(decoding: data, as: UTF8.self)
                            print("\(str)")
                            guard let member = try? JSONDecoder().decode(QTAuthMember.self, from: data) else {
                                callback(nil, QTAuthError.parserError)
                                return
                                
                            }
                            callback(member, nil)
        })
    }
    
    func signup(with signupRequest: QTAuthSignupRequest, callback: @escaping (Any?, Error?) -> Void) {
        
        let urlStr = "\(authConfig.emailAuthBaseUrl ?? "")\(Api.signUp.rawValue)" 
        let params = signupRequest.dictionary
        httpClient.postData(with: urlStr,
                           param: params,
                           useXqtAuth: true,
                           callback: {data, error in
            
            guard let data = data, error == nil else {
                callback(nil, error)
                return
            }
            guard let member = try? JSONDecoder().decode(QTAuthMember.self, from: data) else {
                callback(nil, QTAuthError.parserError)
                return
            }
            callback(member, nil)
        })
    }
    
    func logout(callback: @escaping (Any?, Error?) -> Void) {
        
    }
}

enum QTAuthHttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum QTAuthHttpError: Error {
    case badRequest
}

 protocol QTAuthHttpClientProtocol {
     func postData(with url: String,
                  param: [String: Any]?,
                  useXqtAuth: Bool,
                  callback:  @escaping (Data?, Error?) -> Void)
}

class QTAuthHttpClient: QTAuthHttpClientProtocol {
    func postData(with urlString: String,
                 param: [String: Any]?,
                 useXqtAuth: Bool = false,
                 callback: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            callback(nil, QTAuthError.invalidBaseUrl)
            return
        }
        var request = URLRequest(url: url)
        if let param = param {
            request.httpBody = NSKeyedArchiver.archivedData(withRootObject: param)
        }
        
        if useXqtAuth == true {
            // TODO: Use actual X-QT-Auth here
            request.addValue("dummy-auth", forHTTPHeaderField: xqtAuthKey)
        }
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request, completionHandler:{ data, response, error  in
            if error != nil {
                callback(nil, error)
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            let status = httpResponse?.statusCode
            if status == 200 || status == 201 {
                callback(data, nil)
                guard let xqtAuth = httpResponse?.allHeaderFields[xqtAuthKey] as? String else {
                    return
                }
                UserDefaults.standard.set(xqtAuth, forKey: xqtAuthKey)
//                UserDefaults.standard.synchronize(
                
            } else {
                callback(nil, error)
            }
        }).resume()
    }
}
