//
//  QTAuthMember.swift
//  QTAuth
//
//  Created by Maulik Sharma on 09/12/19.
//

import Foundation

public struct MemberResponse: Codable {
    public let member: AuthMember?
    public var xQTAuth: String?
    public let provider: String?
}

public struct ErrorResponse: Codable {
    
    struct AuthError: Codable {
        let message: String?
    }
    let error: AuthError?
}

public struct AuthMember: Codable {
    
    public let id: Int?
    public let slug: String?
    public let email: String?
    public let name: String?
    public let bio: String?
    public let metadata: MemberMetadata?
    public let source: String?
    public let verificationStatus: String?
    public let updatedAt: Int64?
    public let lastName: String?
    public let publisherId: Int?
    public let avatarUrl: String?
    public let firstName: String?
    public let communicationEmail: String?
    public let canLogin: Bool?
    public let avatarS3Key: String?
    public let twitterHandle: String?
    public let createdAt: Int64?
    
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
    
    public init(from decoder: Decoder) throws {
        //Using try? and not decodeIfPresent because some keys are still present but have null values.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        slug = try? container.decode(String.self, forKey: .slug)
        email = try? container.decode(String.self, forKey: .email)
        name = try? container.decode(String.self, forKey: .name)
        bio = try? container.decode(String.self, forKey: .bio)
        metadata = try? container.decode(MemberMetadata.self, forKey: .metadata)
        source = try? container.decode(String.self, forKey: .source)
        verificationStatus = try? container.decode(String.self, forKey: .verificationStatus)
        updatedAt = try? container.decode(Int64.self, forKey: .updatedAt)
        lastName = try? container.decode(String.self, forKey: .lastName)
        publisherId = try? container.decode(Int.self, forKey: .publisherId)
        avatarUrl = try? container.decode(String.self, forKey: .avatarUrl)
        firstName = try? container.decode(String.self, forKey: .firstName)
        communicationEmail = try? container.decode(String.self, forKey: .verificationStatus)
        canLogin = try? container.decode(Bool.self, forKey: .canLogin)
        avatarS3Key = try? container.decode(String.self, forKey: .avatarS3Key)
        twitterHandle = try? container.decode(String.self, forKey: .twitterHandle)
        createdAt = try? container.decode(Int64.self, forKey: .createdAt)
    }
}

public struct MemberMetadata: Codable {
//    let isBridgeKeeperUserCreated: Bool?
    let dob: String?
    let gender: String?
    let address: String?
    let contact: String?
    
    enum CodingKeys: String, CodingKey {
//        case isBridgeKeeperUserCreated = "is-bridge-keeper-user-created"
        case dob, gender, address
        case contact = "contact-number"
    }

}

public struct ImageSignInData: Codable {
    let action: String?
    let key: String?
    let content_Type: String?
    let policy: String?
    let acl: String?
    let success_action_status: String?
    let awsAccessKeyId: String?
    let signature: String?
    
    enum CodingKeys: String, CodingKey {
        case action, key, policy, acl, signature
        case content_Type = "Content-Type"
        case success_action_status = "success_action_status"
        case awsAccessKeyId = "AWSAccessKeyId"
    }
}
struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String, withType type: String, fileName: String) {
        self.key = key
        self.mimeType = type
        self.filename = fileName
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
    
}
struct MembersProfile: Codable {
    let id: Int?
    let publisher_id: Int?
    let name: String?
    let avatar_s3_key: String?
    let avatar_url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case publisher_id = "publisher-id"
        case avatar_s3_key = "avatar-s3-key"
        case avatar_url = "avatar-url"
    }
}
