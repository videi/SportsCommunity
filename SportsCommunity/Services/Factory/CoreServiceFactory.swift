//
//  CoreServiceFactory.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 07.02.2025.
//

import Foundation
import Alamofire

protocol CoreServiceFactory: CoreServiceDependecy {
    func makeAuthenticatedNetworkService() -> NetworkService
}
protocol CoreServiceDependecy: ServiceDependency {
    var userSession: UserSessionManager { get }
    var tokenManager: TokenManager { get }
    var networkMonitoring: NetworkMonitoringProtocol { get }
}

extension CoreServiceFactory {
    func makeAuthenticatedNetworkService() -> NetworkService {
        let authenticator = OAuthAuthenticator(userSession: self.userSession, tokenManager: self.tokenManager)
        let interceptor = AuthenticationInterceptor(authenticator: authenticator, credential: userSession.getCredential())
        
        #if MOCK
        
        MockServerService.shared.setupProfile()
        MockServerService.shared.setupEvents()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: config)
        
        #else
        
        let session = Session(interceptor: interceptor)
        
        #endif
        
        return NetworkService(session: session)
    }
}
