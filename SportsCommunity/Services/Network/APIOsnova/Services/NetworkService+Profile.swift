//
//  NetworkService+User.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 28.01.2025.
//

import Foundation
import Alamofire

public protocol ProfileNetworkProtocol {
    func getProfile(completion: @escaping (Result<ProfileAPI.Model, Error>) -> Void)
    func getProfileAsync() async throws -> ProfileAPI.Model
    func updateUserData(user: UserAPI.Request.Update, completion: @escaping (Result<UserAPI.Response.Update, Error>) -> Void)
}

extension NetworkService: ProfileNetworkProtocol {
    public func getProfile(completion: @escaping (Result<ProfileAPI.Model, Error>) -> Void) {
        self.baseRequest(convertible: ProfileAPI.Endpoint.getProfile, completion: completion)
    }
    
    public func getProfileAsync() async throws -> ProfileAPI.Model {
        try await self.baseRequest(convertible: ProfileAPI.Endpoint.getProfile)
    }
    
    public func updateUserData(user: UserAPI.Request.Update, completion: @escaping (Result<UserAPI.Response.Update, Error>) -> Void) {
        self.baseRequest(convertible: ProfileAPI.Endpoint.updateProfile(user: user), completion: completion)
    }
}
