//
//  MainServiceFactory.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 30.01.2025.
//

import Foundation
import Alamofire

protocol MainServiceFactory: MainServiceDependecy {
    func profileProvider() -> ProfileNetworkProtocol
    func eventsProvider() -> EventsNetworkProtocol
}
protocol MainServiceDependecy: ServiceDependency {
    func makeAuthenticatedNetworkService() -> NetworkService
    var userSession: UserSessionManager { get }
}

extension MainServiceFactory {
    func profileProvider() -> ProfileNetworkProtocol {
        self.makeAuthenticatedNetworkService()
    }
    
    func eventsProvider() -> EventsNetworkProtocol {
        self.makeAuthenticatedNetworkService()
    }
}
