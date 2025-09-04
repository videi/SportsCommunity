//
//  Profile.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 16.08.2025.
//

import Foundation

internal struct User {
    var id: Int
    var phone: String?
    var name: String?
    var surname: String?
    var email: String?
    var birthday: Date?
}

extension User {
    init(from: UserAPI.Model) throws {
        
        guard let idUser = Int(from.id) else {
            throw DecodingError.valueNotFound(Int.Type.self,
                                              DecodingError.Context(
                                                codingPath: [],
                                                debugDescription: "User ID value is missing."
                                              )
            )
        }
        
        self.id = idUser
        self.name = from.name
        self.surname = from.surname
        self.email = from.email
        self.phone = from.phone
        self.birthday = try from.birthday.toDate()
    }
    
    init(from: UserAPI.Response.Update) throws {
        
        guard let idUser = Int(from.id) else {
            throw DecodingError.valueNotFound(Int.Type.self,
                                              DecodingError.Context(
                                                codingPath: [],
                                                debugDescription: "User ID value is missing."
                                              )
            )
        }
        
        self.id = idUser
        self.name = from.name
        self.surname = from.surname
        self.email = from.email
        self.birthday = try from.birthday.toDate()
    }
}

extension User {
    func toRequestUpdate() throws -> UserAPI.Request.Update {
        guard self.id > 0 else {
            throw DecodingError.valueNotFound(Int.Type.self,
                                              DecodingError.Context(
                                                codingPath: [],
                                                debugDescription: "User ID value is missing."
                                              )
            )
        }
        
        return UserAPI.Request.Update(
            id: String(self.id),
            name: self.name,
            surname: self.surname,
            email: self.email,
            birthday: self.birthday?.toString(format: "yyyy-MM-dd")
        )
    }
}

extension User {
    struct ValidationError: Error {
        let message: String
    }
}
