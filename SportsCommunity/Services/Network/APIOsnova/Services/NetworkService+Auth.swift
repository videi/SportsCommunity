//
//  NetworkService+Auth.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 28.01.2025.
//

import Foundation
import Alamofire


public protocol AuthNetworkProtocol {
    func sendPhoneNumber(phoneNumber: String, completion: @escaping (Result<AuthPhoneNumberResponse, Error>) -> Void)
    func sendSMSCode(authCodeRequest: AuthCodeRequest, completion: @escaping (Result<AuthTokenResponse, Error>) -> Void)
    func refreshAuthToken(refreshToken: String, completion: @escaping (Result<AuthRefreshTokenResponse, Error>) -> Void)
}

extension NetworkService: AuthNetworkProtocol {
    
    public func sendPhoneNumber(phoneNumber: String, completion: @escaping (Result<AuthPhoneNumberResponse, Error>) -> Void) {
        self.baseRequest(convertible: AuthRequest.sendPhoneNumber(phoneNumber: phoneNumber), completion: completion)
    }
    
    public func sendSMSCode(authCodeRequest: AuthCodeRequest, completion: @escaping (Result<AuthTokenResponse, Error>) -> Void) {
        self.baseRequest(convertible: AuthRequest.sendSMSCode(authCodeRequest: authCodeRequest), completion: completion)
    }
    
    public func refreshAuthToken(refreshToken: String, completion: @escaping (Result<AuthRefreshTokenResponse, Error>) -> Void) {
        self.baseRequest(convertible: AuthRequest.refreshAuthToken(refreshToken: refreshToken), completion: completion)
    }
}

// MARK: - Auth models

enum AuthRequest: URLRequestBuilder {
    case sendPhoneNumber(phoneNumber: String)
    case sendSMSCode(authCodeRequest: AuthCodeRequest)
    case refreshAuthToken(refreshToken: String)
    
    var path: String {
        
        switch self {
        case .sendPhoneNumber:
            return "api/v1/auth/send-code"
        case .sendSMSCode:
            return "api/v1/auth/verify/code"
        case .refreshAuthToken:
            return "api/v1/auth/token/refresh"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendPhoneNumber, .sendSMSCode, .refreshAuthToken:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            return nil
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .sendPhoneNumber(let phoneNumber):
            return [
                "phone": phoneNumber,
            ]
        case .sendSMSCode(let authCodeRequest):
            // TODO: Сделать десереализацию объекта
            return [
                "requestId": authCodeRequest.requestId,
                "code": authCodeRequest.code,
                "phone": authCodeRequest.phone
            ]
            //return authCodeRequest.toDictionary()
        case .refreshAuthToken(let refreshToken):
            return [
                "refreshToken": refreshToken
            ]
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

public struct AuthCodeRequest: Codable, Sendable {
    let requestId: String
    let code: String
    let phone: String
}

public struct AuthPhoneNumberResponse: Decodable {
    let expiresAt: String
    let requestId: String
    let retryAfter: Int
}

public struct AuthTokenResponse : Decodable {
    let accessToken: String
    let accountStatus: String
    let refreshToken: String
}

public struct AuthRefreshTokenResponse: Decodable {
    let accessTokenExpiration: Int
    let refreshTokenExpiration: Int
    let refreshToken: String
    let accessToken: String
}
