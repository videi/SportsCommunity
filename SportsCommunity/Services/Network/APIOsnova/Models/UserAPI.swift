//
//  User.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 20.08.2025.
//

import Foundation

public enum UserAPI {
    
    struct Model: Codable, Sendable {
        let id: String
        let accountStatus: AccountStatus
        let phone: String
        let name: String?
        let surname: String?
        let email: String?
        let birthday: String?
    }
    
    public enum Request {
        public struct Update: Codable, Sendable {
            let id: String
            let name: String?
            let surname: String?
            let email: String?
            let birthday: String?
        }
    }
    
    public enum Response {
        public struct Update: Decodable, Sendable {
            let id: String
            let name: String?
            let surname: String?
            let email: String?
            let birthday: String?
        }
    }

}

enum AccountStatus: String, Codable {
    
    case pending = "pending"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = AccountStatus(rawValue: rawValue) ?? .unknown
    }
}
