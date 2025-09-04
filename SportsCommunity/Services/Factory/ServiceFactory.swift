//
//  ServiceFactory.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 30.01.2025.
//

import Foundation

public class ServiceFactory {
    let userSession: UserSessionManager
    private(set) var networkMonitoring: NetworkMonitoringProtocol
    
    init(userSession: UserSession) {
        self.userSession = userSession
        self.networkMonitoring = NetworkMonitoringService()
    }
}

extension ServiceFactory: AuthServiceFactory { 
    // MARK: Здесь может содержаться логика для настройки фабрики или сервис-локатор или считать что-то нужное из базы данных
}

extension ServiceFactory: MainServiceFactory {
}

extension ServiceFactory: CoreServiceFactory {
    
}
