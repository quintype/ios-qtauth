//
//  QTMemeber.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 28/10/19.
//

import Foundation
struct QTAuthMetaData: Codable {
    let isBridgeKeeperUserCreated: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isBridgeKeeperUserCreated = "is-bridge-keeper-user-created"
    }
    
}

struct QTAuthMemeber: Codable {
    
    let id: Int?
    let slug: String?
    let email: String?
    let name: String?
    let bio: String?
    let metadata: QTAuthMetaData?
    let source: String?
    
    let verificationStatus: String?
    let updatedAt: Int64?
    let lastName: String?
    let publisherId: String?
    let avatarUrl: String?
    let firstName: String?
    let communicationEmail: String
    let canLogin: Bool?
    let avatarS3Key: String?
    let twitterHandle: String?
    let createdAt: Int64?
    
    enum CodingKeys: String, CodingKey {
        case id, email, slug, name, source, bio, metadata
        case verificationStatus = "verification-status"
        case updatedAt = "updated-at"
        case lastName = "last-name"
        case publisherId = "publisher-id"
        case avatarUrl = "avatar-url"
        case firstName = "first-name"
        case communicationEmail = "communication-email"
        case canLogin = "can-login"
        case avatarS3Key = "avatar-s3-key"
        case twitterHandle = "twitterHandle"
        case createdAt = "created-at"
    }
}

public struct QTAuthSignupRequest {
    
    let welcomeMailDeley: Int?
    let name: String?
    let email: String?
    let username: String?
    let password: String?
    let dontLogin: Bool?
    let metadata: Any?
    
    public init(name: String, email: String, username: String, password: String, dontLogin: Bool? = false, metadata: Any? = nil, welcomeMailDeley: Int = 0) {
        self.name = name
        self.email = email
        self.username = username
        self.password = password
        self.dontLogin = dontLogin
        self.metadata = metadata
        self.welcomeMailDeley = welcomeMailDeley
    }
    
    public init?(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.dontLogin = dictionary["dontLogin"] as? Bool ?? true
        self.metadata = dictionary["metadata"]
        self.welcomeMailDeley = dictionary["welcomeMailDeley"] as? Int ?? 0
    }
    
    var dictionary: [String: Any] {
        
        return ["send-welcome-email-delay": self.welcomeMailDeley as Any,
                "name": self.name as Any,
                "email": self.email as Any,
                "username": self.username as Any,
                "password": self.password as Any,
                "dont-login": self.dontLogin as Any,
                "metadata": self.metadata as Any
        ]
        
    }
}
