//
//  Event.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 12.08.2025.
//

import Foundation

internal enum Event {
    
    internal struct View {
        let id: Int
        let name: String
        let participants: Int
        var maxParticipants: Int
        var date: Date
        var address: String
        var sportType: SportType
    }

    internal struct Create {
        let name: String
        let maxParticipants: Int
        let date: Date
        let address: String
        let sportType: SportType
    }
    
    internal struct Edit {
        let id: Int
        var maxParticipants: Int
        var date: Date
        var address: String
        var sportType: SportType
    }
}


extension Event.View {
    init(from: EventAPI.Model) throws {
        self.id = from.id
        self.name = from.name
        self.maxParticipants = from.maxParticipants
        self.participants = from.participants
        self.date = try from.date.toDate(format: "yyyy-MM-dd HH:mm")
        self.address = from.address
        guard let sportType = SportType(rawValue: from.sportType) else {
            throw DecodingError.valueNotFound(
                String.self,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "SportType value is missing or invalid."
                )
            )
        }
        self.sportType = sportType
    }
}

extension Event.Create {
    func toEventAPI() -> EventAPI.Request.Add {
        return EventAPI.Request.Add(name: self.name,
                                    maxParticipants: self.maxParticipants,
                                    date: self.date.toString(dateStyle: .medium, timeStyle: .short),
                                    address: self.address,
                                    sportType: self.sportType.rawValue)
    }
}

extension Event.Edit {
    init(from: EventAPI.Response.Update) throws {
        self.id = from.id
        self.maxParticipants = from.maxParticipants
        self.date = try from.date.toDate(dateStyle: .medium, timeStyle: .short)
        self.address = from.address
        guard let sportType = SportType(rawValue: from.sportType) else {
            throw DecodingError.valueNotFound(
                String.self,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "SportType value is missing or invalid."
                )
            )
        }
        self.sportType = sportType
    }
    
    func toEventAPI() -> EventAPI.Request.Update {
        return EventAPI.Request.Update(id: self.id,
                                       maxParticipants: self.maxParticipants,
                                       date: self.date.toString(dateStyle: .medium, timeStyle: .short),
                                       address: self.address,
                                       sportType: self.sportType.rawValue)
    }
}

enum EventEditorMode {
    case create
    case edit(Event.View)
}

enum SportType: String, CaseIterable, Codable {
    case football, volleyball, hockey, tennis, pingpong
    
    //TODO: Localization
    
    var title : String {
        switch self {
        case .football:
            return "Футбол"
        case .volleyball:
            return "Волейбол"
        case .hockey:
            return "Хоккей"
        case .tennis:
            return "Теннис"
        case .pingpong:
            return "Настольный теннис"
        }
    }
}
