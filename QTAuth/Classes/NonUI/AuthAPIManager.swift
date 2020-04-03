//
//  AuthAPIManager.swift
//  QTAuth
//
//  Created by Maulik Sharma on 09/12/19.
//

import Foundation

public class AuthAPIManager {
    
    let router = Router<AuthEndPoints>()
    
    func signIn(email: String, password: String, callback: @escaping (MemberResponse?, NetworkError?) -> Void) {
        self.router.request(.signIn(email: email, password: password)) { (data , response, error) in
            guard error == nil else {
                callback(nil, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        callback(nil, NetworkError.custom(message: "No data received"))
                        return
                    }
                    do {
                        var memberResponse = try JSONDecoder().decode(MemberResponse.self, from: data)
                        if let xQTAuth = response.allHeaderFields["x-qt-auth"] as? String {
                            memberResponse.xQTAuth = xQTAuth
                        }
                        callback(memberResponse, nil)
                    } catch(let decodingError) {
                        callback(nil, NetworkError.parsingError)
                        print(String(describing: decodingError))
                    }
                case .failure(let message):
                    guard let data = data else {
                        print("API Failure Log: " + message)
                        callback(nil, NetworkError.custom(message: message))
                        return
                    }
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        callback(nil, NetworkError.custom(message: errorResponse.error?.message ?? message))
                    }
                }
                return
            }
            callback(nil, NetworkError.custom(message: "No response received"))
        }
    }
    
    func signUp(name: String, email: String, password: String, callback: @escaping (MemberResponse?, NetworkError?) -> Void) {
        self.router.request(.signUp(email: email, password: password, name: name)) { (data , response, error) in
            guard error == nil else {
                callback(nil, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        callback(nil, NetworkError.custom(message: "No data received"))
                        return
                    }
                    do {
                        var memberResponse = try JSONDecoder().decode(MemberResponse.self, from: data)
                        if let xQTAuth = response.allHeaderFields["x-qt-auth"] as? String {
                            memberResponse.xQTAuth = xQTAuth
                        }
                        callback(memberResponse, nil)
                    } catch(let decodingError) {
                        callback(nil, NetworkError.parsingError)
                        print(String(describing: decodingError))
                    }
                case .failure(let message):
                    guard let data = data else {
                        print("API Failure Log: " + message)
                        callback(nil, NetworkError.custom(message: message))
                        return
                    }
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        callback(nil, NetworkError.custom(message: errorResponse.error?.message ?? message))
                    }
                }
                return
            }
            callback(nil, NetworkError.custom(message: "No response received"))
        }
    }
    
    func sendOTP(email: String, callback: @escaping (Bool, NetworkError?) -> Void) {
        self.router.request(.emailVerification(email: email)) { (_ , response, error) in
            guard error == nil else {
                callback(false, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    callback(true, nil)
                case .failure(let message):
                    print("API Failure Log: " + message)
                    callback(false, NetworkError.custom(message: message))
                }
                return
            }
            callback(false, NetworkError.custom(message: "No response received"))
        }
    }
    
    func verifyOTP(id: Int, otp: Int, callback: @escaping (MemberResponse?, NetworkError?) -> Void) {
        self.router.request(.verifyOTP(id: id, otp: otp)) { (data , response, error) in
            guard error == nil else {
                callback(nil, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        callback(nil, NetworkError.custom(message: "No data received"))
                        return
                    }
                    do {
                        var memberResponse = try JSONDecoder().decode(MemberResponse.self, from: data)
                        if let xQTAuth = response.allHeaderFields["x-qt-auth"] as? String {
                            memberResponse.xQTAuth = xQTAuth
                        }
                        callback(memberResponse, nil)
                    } catch(let decodingError) {
                        callback(nil, NetworkError.parsingError)
                        print(String(describing: decodingError))
                    }
                case .failure(let message):
                    guard let data = data else {
                        print("API Failure Log: " + message)
                        callback(nil, NetworkError.custom(message: message))
                        return
                    }
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        callback(nil, NetworkError.custom(message: errorResponse.error?.message ?? message))
                    }
                }
                return
            }
            callback(nil, NetworkError.custom(message: "No response received"))
        }
    }
    
    func resetPassword(email: String, callback: @escaping (Bool, NetworkError?) -> Void) {
        self.router.request(.resetPassword(email: email)) { (_ , response, error) in
            guard error == nil else {
                callback(false, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    callback(true, nil)
                case .failure(let message):
                    print("API Failure Log: " + message)
                    callback(false, NetworkError.custom(message: message))
                }
                return
            }
            callback(false, NetworkError.custom(message: "No response received"))
        }
    }
    
    func changePassword(id: Int, otp: Int, password: String, xQTAuth: String, callback: @escaping (MemberResponse?, NetworkError?) -> Void) {
        self.router.request(.changePassword(id: id, otp: otp, password: password, xQTAuth: xQTAuth)) { (data , response, error) in
            guard error == nil else {
                callback(nil, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        callback(nil, NetworkError.custom(message: "No data received"))
                        return
                    }
                    do {
                        var memberResponse = try JSONDecoder().decode(MemberResponse.self, from: data)
                        if let xQTAuth = response.allHeaderFields["x-qt-auth"] as? String {
                            memberResponse.xQTAuth = xQTAuth
                        }
                        callback(memberResponse, nil)
                    } catch(let decodingError) {
                        callback(nil, NetworkError.parsingError)
                        print(String(describing: decodingError))
                    }
                case .failure(let message):
                    guard let data = data else {
                        print("API Failure Log: " + message)
                        callback(nil, NetworkError.custom(message: message))
                        return
                    }
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        callback(nil, NetworkError.custom(message: errorResponse.error?.message ?? message))
                    }
                }
                return
            }
            callback(nil, NetworkError.custom(message: "No response received"))
        }
    }
    
    func socialSignIn(provider: String, accessToken: String, callback: @escaping (MemberResponse?, NetworkError?) -> Void) {
        self.router.request(.socialLogin(platform: provider, token: accessToken)) { (data , response, error) in
            guard error == nil else {
                callback(nil, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        callback(nil, NetworkError.custom(message: "No data received"))
                        return
                    }
                    do {
                        var memberResponse = try JSONDecoder().decode(MemberResponse.self, from: data)
                        if let xQTAuth = response.allHeaderFields["x-qt-auth"] as? String {
                            memberResponse.xQTAuth = xQTAuth
                        }
                        callback(memberResponse, nil)
                    } catch(let decodingError) {
                        callback(nil, NetworkError.parsingError)
                        print(String(describing: decodingError))
                    }
                case .failure(let message):
                    guard let data = data else {
                        print("API Failure Log: " + message)
                        callback(nil, NetworkError.custom(message: message))
                        return
                    }
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        callback(nil, NetworkError.custom(message: errorResponse.error?.message ?? message))
                    }
                }
                return
            }
            callback(nil, NetworkError.custom(message: "No response received"))
        }
    }
    
    func fetchMember(xQTAuth: String, callback: @escaping (MemberResponse?, NetworkError?) -> Void) {
        self.router.request(.fetchMemberInfo(xQTAuth: xQTAuth)) { (data , response, error) in
            guard error == nil else {
                callback(nil, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        callback(nil, NetworkError.custom(message: "No data received"))
                        return
                    }
                    do {
                        var memberResponse = try JSONDecoder().decode(MemberResponse.self, from: data)
                        if let xQTAuth = response.allHeaderFields["x-qt-auth"] as? String {
                            memberResponse.xQTAuth = xQTAuth
                        } else {
                            memberResponse.xQTAuth = xQTAuth
                        }
                        callback(memberResponse, nil)
                    } catch(let decodingError) {
                        callback(nil, NetworkError.parsingError)
                        print(String(describing: decodingError))
                    }
                case .failure(let message):
                    guard let data = data else {
                        print("API Failure Log: " + message)
                        callback(nil, NetworkError.custom(message: message))
                        return
                    }
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        callback(nil, NetworkError.custom(message: errorResponse.error?.message ?? message))
                    }
                }
                return
            }
            callback(nil, NetworkError.custom(message: "No response received"))
        }
    }
    
    func updateMember(metadata: MemberMetadata, xQTAuth: String, callback: @escaping (Bool, NetworkError?) -> Void) {
        self.router.request(.updateMemberMetadata(metadata: metadata, xQTAuth: xQTAuth)) { (_ , response, error) in
            guard error == nil else {
                callback(false, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    callback(true, nil)
                case .failure(let message):
                    print("API Failure Log: " + message)
                    callback(false, NetworkError.custom(message: message))
                }
                return
            }
            callback(false, NetworkError.custom(message: "No response received"))
        }
    }
    
    func signOut(xQTAuth: String, callback: @escaping (Bool, NetworkError?) -> Void) {
        self.router.request(.signOut(xQTAuth: xQTAuth)) { (_ , response, error) in
            guard error == nil else {
                callback(false, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    callback(true, nil)
                case .failure(let message):
                    print("API Failure Log: " + message)
                    callback(false, NetworkError.custom(message: message))
                }
                return
            }
            callback(false, NetworkError.custom(message: "No response received"))
        }
    }
    func imageSignIn(imageName: String, fileType: String, callBack: @escaping(ImageSignInData?, NetworkError?) -> Void) {
        self.router.request(.imageSignIn(fileName: imageName, imageType: fileType)) { (data, response, error) in
            guard error == nil else {
                callBack(nil, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        callBack(nil, NetworkError.custom(message: "No data received"))
                        return
                    }
                    do {
                        let imageSignInResponse = try JSONDecoder().decode(ImageSignInData.self, from: data)
                        callBack(imageSignInResponse, nil)
                    } catch(let decodingError) {
                        callBack(nil, NetworkError.parsingError)
                        print(String(describing: decodingError))
                    }
                case .failure(let message):
                    guard let data = data else {
                        print("API Failure Log: " + message)
                        callBack(nil, NetworkError.custom(message: message))
                        return
                    }
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        callBack(nil, NetworkError.custom(message: errorResponse.error?.message ?? message))
                    }
                }
                return
            }
            callBack(nil, NetworkError.custom(message: "No response received"))
        }
    }
    func fetchMemberprofile(tempS3Key: String, userName: String,  xQTAuth: String,callback: @escaping(MembersProfile?, NetworkError?) -> Void) {
        self.router.request(.memberProfile(tempS3key: tempS3Key, userName: userName, xQTAuth: xQTAuth)) { (data, response, error) in
            guard error == nil else {
                callback(nil, error as? NetworkError ?? NetworkError.custom(message: error!.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        callback(nil, NetworkError.custom(message: "No data received"))
                        return
                    }
                    do {
                        let imageMembersProfile = try JSONDecoder().decode(MembersProfile.self, from: data)
                        callback(imageMembersProfile, nil)
                    } catch(let decodingError) {
                        callback(nil, NetworkError.parsingError)
                        print(String(describing: decodingError))
                    }
                case .failure(let message):
                    guard let data = data else {
                        print("API Failure Log: " + message)
                        callback(nil, NetworkError.custom(message: message))
                        return
                    }
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        callback(nil, NetworkError.custom(message: errorResponse.error?.message ?? message))
                    }
                }
                return
            }
            callback(nil, NetworkError.custom(message: "No response received"))
            
        }
        
    }
    
}
