//
//  SplashScreenViewModel.swift
//  ApplicationName
//
//  Created by Илья Макаров on 14.02.2025
//

import Foundation

final class SplashScreenViewModel {
    
    // MARK: - Property
    
    private let router: SplashScreenRouter
    private let userSession: UserSessionManager
    private let networkMonitoring: NetworkMonitoringProtocol
    
    // MARK: - Closure
    // TODO: Вызов Alert
    
    // MARK: - Init
    
    init(router: SplashScreenRouter, serviceFactory: ServiceFactory) {
        
        self.router = router
        self.userSession = serviceFactory.userSession
        self.networkMonitoring = serviceFactory.networkMonitoring
    }
    
    // MARK: - Method
    
    func checkNetworkConnection() {
        
        networkMonitoring.checkConnection() { [weak self] isConnected in
            if isConnected {
                self?.checkUserAuth()
            } else {
                // TODO: Выводи сообщение о том что нет подключения к сети
            }
        }
        
    }
    
    func checkUserAuth() {
        if userSession.isAuthenticated {
            router.goToMainFlow()
        }
        else {
            router.goToAuthFlow()
        }
    }
}
