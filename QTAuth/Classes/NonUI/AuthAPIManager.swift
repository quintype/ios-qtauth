//
//  AuthAPIManager.swift
//  QTAuth
//
//  Created by Maulik Sharma on 09/12/19.
//

import Foundation

class AuthAPIManager {
    
    let router = Router<AuthEndPoints>()
    
    func signIn(email: String, password: String, callback: @escaping (SignInResponse?, Error?) -> Void) {
        self.router.request(.signIn(email: email, password: password)) { (data , response, error) in
            guard error == nil else {
                callback(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = ResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        callback(nil, NetworkError.Custom(message: "No data received"))
                        break
                    }
                    do {
                        let result = try JSONDecoder().decode(SignInResponse.self, from: data)
                        callback(result, nil)
                    } catch(let decodingError) {
                        callback(nil, decodingError)
                        print(String(describing: decodingError))
                    }
                case .failure(let message):
                    callback(nil, NetworkError.Custom(message: message))
                }
                return
            }
            callback(nil, NetworkError.Custom(message: "No response received"))
        }
    }
    
}
