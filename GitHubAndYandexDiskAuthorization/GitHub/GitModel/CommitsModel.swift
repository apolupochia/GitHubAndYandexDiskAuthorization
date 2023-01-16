// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct CommitsModel: Codable {
    let sha: String
    let node_id: String
    let commit: Commit
//    let url, htmlURL, commentsURL: String
//    let author, committer: WelcomeAuthor
//    let parents: [Parent]

//    enum CodingKeys: String, CodingKey {
//        case sha
//        case node_id
//        case commit, url
//        case html_url
//        case commentsURL
//        case author, committer, parents
//    }
}

// MARK: - WelcomeAuthor
struct WelcomeAuthor: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL: String
    let gistsURL: String
    let starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool

//    enum CodingKeys: String, CodingKey {
//        case login, id
//        case nodeID
//        case avatarURL
//        case gravatarID
//        case url
//        case htmlURL
//        case followersURL
//        case followingURL
//        case gistsURL
//        case starredURL
//        case subscriptionsURL
//        case organizationsURL
//        case reposURL
//        case eventsURL
//        case receivedEventsURL
//        case type
//        case siteAdmin
//    }
}

// MARK: - Commit
struct Commit: Codable {
    let author : CommitAuthor
    let committer: CommitAuthor
    let message: String
    let tree: Tree
    let url: String
    let comment_count: Int
   // let verification: Verification

//    enum CodingKeys: String, CodingKey {
//        case author, committer, message, tree, url
//        case commentCount
//        case verification
//    }
}

// MARK: - CommitAuthor
struct CommitAuthor: Codable {
    let name: String
    let email: String
    let date: String
}

// MARK: - Tree
struct Tree: Codable {
    let sha: String
    let url: String
}

// MARK: - Verification
//struct Verification: Codable {
//    let verified: Bool
//    let reason: Reason
//    let signature, payload: JSONNull?
//}

enum Reason: String, Codable {
    case unsigned = "unsigned"
}

// MARK: - Parent
struct Parent: Codable {
    let sha: String
    let url : String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case sha, url
        case htmlURL
    }
}

//typealias Welcome = [WelcomeElement]
//
//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
//
