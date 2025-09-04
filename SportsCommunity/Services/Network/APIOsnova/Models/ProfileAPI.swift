//
//  Profile.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 20.08.2025.
//

import Foundation
import Alamofire

public enum ProfileAPI {
    
    // Основная модель
    public struct Model: Codable {
        let user: UserAPI.Model
        let onboardingFinished: Bool
    }
    
    enum Request {
        
    }
    
    enum Response {
        struct Single: Encodable {
            let user: UserAPI.Model
            let onboardingFinished: Bool
        }
    }
    
    enum Endpoint: URLRequestBuilder {
        case getProfile, updateProfile(user: UserAPI.Request.Update)
        
        var path: String {
            switch self {
            case .getProfile:
                return "api/v1/profile"
            case .updateProfile:
                return "api/v1/profile/update"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getProfile:
                return .get
            case .updateProfile:
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
            case .getProfile:
                return [:]
            case .updateProfile(let user):
                return user.toJSONDictionary()
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
}
