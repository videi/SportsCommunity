//
//  NetworlService+Events.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 14.08.2025.
//

import Foundation

public protocol EventsNetworkProtocol {
    func getEvents(completion: @escaping (Result<[EventAPI.Model], Error>) -> Void)
    func addEvent(_ event: EventAPI.Request.Add, completion: @escaping (Result<EventAPI.Response.Add, Error>) -> Void)
    func updateEvent(_ event: EventAPI.Request.Update, completion: @escaping (Result<EventAPI.Response.Update, Error>) -> Void)
    func removeEvent(_ event: EventAPI.Request.Remove, completion: @escaping (Result<Void, Error>) -> Void)
}

extension NetworkService: EventsNetworkProtocol {
    public func addEvent(_ event: EventAPI.Request.Add, completion: @escaping (Result<EventAPI.Response.Add, Error>) -> Void) {
        self.baseRequest(convertible: EventAPI.Endpoint.addEvent(event), completion: completion)
    }
    
    public func updateEvent(_ event: EventAPI.Request.Update, completion: @escaping (Result<EventAPI.Response.Update, Error>) -> Void) {
        self.baseRequest(convertible: EventAPI.Endpoint.updateEvent(event), completion: completion)
    }
    
    public func removeEvent(_ event: EventAPI.Request.Remove, completion: @escaping (Result<Void, Error>) -> Void) {
        self.baseRequest(convertible: EventAPI.Endpoint.removeEvent(event), completion: completion)
    }
    
    public func getEvents(completion: @escaping (Result<[EventAPI.Model], Error>) -> Void) {
        self.baseRequest(convertible: EventAPI.Endpoint.getEvents, completion: completion)
    }
}
