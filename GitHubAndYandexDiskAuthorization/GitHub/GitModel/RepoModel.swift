//
//  RepoModel.swift
//  Реализация авторизации в приложении
//
//  Created by Алёша Виноградов on 06.12.2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct RepoModel: Codable {
    let id: Int
    let node_id : String
    let name : String
    let full_name: String
//    let welcomePrivate: Bool
    let owner: Owner
//    let html_url: String
//    let welcomeDescription: JSONNull?
//    let fork: Bool
    let url: String
//    let forksURL: String
//    let keysURL, collaboratorsURL: String
//    let teamsURL, hooksURL: String
//    let issueEventsURL: String
//    let eventsURL: String
//    let assigneesURL, branchesURL: String
//    let tagsURL: String
//    let blobsURL, gitTagsURL, gitRefsURL, treesURL: String
//    let statusesURL: String
//    let languagesURL, stargazersURL, contributorsURL, subscribersURL: String
//    let subscriptionURL: String
//    let commitsURL, gitCommitsURL, commentsURL, issueCommentURL: String
//    let contentsURL, compareURL: String
//    let mergesURL: String
//    let archiveURL: String
//    let downloadsURL: String
//    let issuesURL, pullsURL, milestonesURL, notificationsURL: String
//    let labelsURL, releasesURL: String
//    let deploymentsURL: String
//    let createdAt, updatedAt, pushedAt: Date
//    let gitURL, sshURL: String
//    let cloneURL: String
//    let svnURL: String
//    let homepage: JSONNull?
//    let size, stargazersCount, watchersCount: Int
//    let language: String
//    let hasIssues, hasProjects, hasDownloads, hasWiki: Bool
//    let hasPages, hasDiscussions: Bool
    let forks_count: Int
//    let mirrorURL: JSONNull?
//    let archived, disabled: Bool
//    let openIssuesCount: Int
//    let license: JSONNull?
//    let allowForking, isTemplate, webCommitSignoffRequired: Bool
//    let topics: [JSONAny]
//    let visibility: String
    let forks : Int
//    let openIssues: Int
    let watchers: Int
//    let defaultBranch: String
//    let permissions: Permissions

//    enum CodingKeys: String, CodingKey {
//        case id
//        case node_id
//        case name
//        case full_name
////        case welcomePrivate
//        case owner
//  //      case html_url
////        case welcomeDescription
////        case fork,
//  //      case url
////        case forksURL
////        case keysURL
////        case collaboratorsURL
////        case teamsURL
////        case hooksURL
////        case issueEventsURL
////        case eventsURL
////        case assigneesURL
////        case branchesURL
////        case tagsURL
////        case blobsURL
////        case gitTagsURL
////        case gitRefsURL
////        case treesURL
////        case statusesURL
////        case languagesURL
////        case stargazersURL
////        case contributorsURL
////        case subscribersURL
////        case subscriptionURL
////        case commitsURL
////        case gitCommitsURL
////        case commentsURL
////        case issueCommentURL
////        case contentsURL
////        case compareURL
////        case mergesURL
////        case archiveURL
////        case downloadsURL
////        case issuesURL
////        case pullsURL
////        case milestonesURL
////        case notificationsURL
////        case labelsURL
////        case releasesURL
////        case deploymentsURL
////        case createdAt
////        case updatedAt
////        case pushedAt
////        case gitURL
////        case sshURL
////        case cloneURL
////        case svnURL
////        case homepage, size
////        case stargazersCount
////        case watchersCount
////        case language
////        case hasIssues
////        case hasProjects
////        case hasDownloads
////        case hasWiki
////        case hasPages
////        case hasDiscussions
////        case forksCount
////        case mirrorURL
////        case archived, disabled
////        case openIssuesCount
////        case license
////        case allowForking
////        case isTemplate
////        case webCommitSignoffRequired
////        case topics, visibility, forks
////        case openIssues
////        case watchers
////        case defaultBranch
////        case permissions
//    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
//    let gravatarID: String
//    let url, htmlURL, followersURL: String
//    let followingURL, gistsURL, starredURL: String
//    let subscriptionsURL, organizationsURL, reposURL: String
//    let eventsURL: String
//    let receivedEventsURL: String
//    let type: String
//    let siteAdmin: Bool

//    enum CodingKeys: String, CodingKey {
//        case login
//        case id
//        case nodenode_id
//        case avatar_url
////        case gravatarID
////        case url
////        case htmlURL
////        case followersURL
////        case followingURL
////        case gistsURL
////        case starredURL
////        case subscriptionsURL
////        case organizationsURL
////        case reposURL
////        case eventsURL
////        case receivedEventsURL
////        case type
////        case siteAdmin
//    }
}

// MARK: - Permissions
struct Permissions: Codable {
    let admin, maintain, push, triage: Bool
    let pull: Bool
}

typealias Welcome = [RepoModel]

// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
////
//    public var hashValue: Int {
////        return 0
////    }
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
//class JSONCodingKey: CodingKey {
//    let key: String
//
//    required init?(intValue: Int) {
//        return nil
//    }
//
//    required init?(stringValue: String) {
//        key = stringValue
//    }
//
//    var intValue: Int? {
//        return nil
//    }
//
//    var stringValue: String {
//        return key
//    }
//}
//
//class JSONAny: Codable {
//
//    let value: Any
//
//    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
//        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
//        return DecodingError.typeMismatch(JSONAny.self, context)
//    }
//
//    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
//        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
//        return EncodingError.invalidValue(value, context)
//    }
//
//    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if container.decodeNil() {
//            return JSONNull()
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if let value = try? container.decodeNil() {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer() {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
//        if let value = try? container.decode(Bool.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Double.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(String.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decodeNil(forKey: key) {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
//        var arr: [Any] = []
//        while !container.isAtEnd {
//            let value = try decode(from: &container)
//            arr.append(value)
//        }
//        return arr
//    }
//
//    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
//        var dict = [String: Any]()
//        for key in container.allKeys {
//            let value = try decode(from: &container, forKey: key)
//            dict[key.stringValue] = value
//        }
//        return dict
//    }
//
//    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
//        for value in array {
//            if let value = value as? Bool {
//                try container.encode(value)
//            } else if let value = value as? Int64 {
//                try container.encode(value)
//            } else if let value = value as? Double {
//                try container.encode(value)
//            } else if let value = value as? String {
//                try container.encode(value)
//            } else if value is JSONNull {
//                try container.encodeNil()
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer()
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
//        for (key, value) in dictionary {
//            let key = JSONCodingKey(stringValue: key)!
//            if let value = value as? Bool {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Int64 {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Double {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? String {
//                try container.encode(value, forKey: key)
//            } else if value is JSONNull {
//                try container.encodeNil(forKey: key)
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer(forKey: key)
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
//        if let value = value as? Bool {
//            try container.encode(value)
//        } else if let value = value as? Int64 {
//            try container.encode(value)
//        } else if let value = value as? Double {
//            try container.encode(value)
//        } else if let value = value as? String {
//            try container.encode(value)
//        } else if value is JSONNull {
//            try container.encodeNil()
//        } else {
//            throw encodingError(forValue: value, codingPath: container.codingPath)
//        }
//    }
//
//    public required init(from decoder: Decoder) throws {
//        if var arrayContainer = try? decoder.unkeyedContainer() {
//            self.value = try JSONAny.decodeArray(from: &arrayContainer)
//        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
//            self.value = try JSONAny.decodeDictionary(from: &container)
//        } else {
//            let container = try decoder.singleValueContainer()
//            self.value = try JSONAny.decode(from: container)
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        if let arr = self.value as? [Any] {
//            var container = encoder.unkeyedContainer()
//            try JSONAny.encode(to: &container, array: arr)
//        } else if let dict = self.value as? [String: Any] {
//            var container = encoder.container(keyedBy: JSONCodingKey.self)
//            try JSONAny.encode(to: &container, dictionary: dict)
//        } else {
//            var container = encoder.singleValueContainer()
//            try JSONAny.encode(to: &container, value: self.value)
//        }
//    }
//}
