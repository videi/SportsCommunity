//
//  EventAPI.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 29.08.2025.
//

import Foundation
import UIKit
import Alamofire

public enum EventAPI {
    
    public struct Model: Codable, Sendable {
        let id: Int
        let name: String
        let participants: Int
        var maxParticipants: Int
        var date: String
        var address: String
        var sportType: String
    }
    
    public enum Request {
        public struct Add: Codable, Sendable {
            let name: String
            let maxParticipants: Int
            let date: String
            var address: String
            let sportType: String
        }
        
        public struct Update: Codable, Sendable {
            let id: Int
            let maxParticipants: Int
            let date: String
            var address: String
            let sportType: String
        }
        
        public struct Remove: Codable, Sendable {
            let id: Int
        }
    }
    
    public enum Response {
        public struct Add: Codable, Sendable {
            let id: Int
        }
        
        public struct Update: Decodable, Sendable {
            let id: Int
            let maxParticipants: Int
            let date: String
            var address: String
            let sportType: String
        }
    }
    
    enum Endpoint: URLRequestBuilder {
        case getEvents,
             addEvent(EventAPI.Request.Add),
             updateEvent(EventAPI.Request.Update),
             removeEvent(EventAPI.Request.Remove)
        
        var path: String {
            switch self {
            case .getEvents:
                return "api/v1/events"
            case .addEvent:
                return "api/v1/events/add"
            case .updateEvent:
                return "api/v1/events/update"
            case .removeEvent:
                return "api/v1/events/remove"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getEvents:
                return .get
            case .addEvent, .updateEvent, .removeEvent:
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
            case .getEvents:
                return [:]
            case .addEvent(let event):
                return event.toJSONDictionary()
            case .updateEvent(let event):
                return event.toJSONDictionary()
            case .removeEvent(let event):
                return event.toJSONDictionary()
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
