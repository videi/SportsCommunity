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
    
    init(
        router: SplashScreenRouter,
        userSession: UserSessionManager,
        networkMonitoring: NetworkMonitoringProtocol
    ) {
        self.router = router
        self.userSession = userSession
        self.networkMonitoring = networkMonitoring
    }
    
    // MARK: - Method
    
    private func checkNetworkConnection() {
        
        networkMonitoring.checkConnection() { [weak self] isConnected in
            if isConnected {
                self?.checkUserAuth()
            } else {
                // TODO: Выводи сообщение о том что нет подключения к сети
            }
        }
        
    }
    
    private func checkUserAuth() {
        if userSession.isAuthenticated {
            router.goToMainFlow()
        }
        else {
            router.goToAuthFlow()
        }
    }
}

extension SplashScreenViewModel: SplashScreenViewOutput {
    func viewDidLoad() {
        self.checkNetworkConnection()
    }
}
