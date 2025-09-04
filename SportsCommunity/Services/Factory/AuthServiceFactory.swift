//
//  CoreServiceFactory.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 30.01.2025.
//

import Foundation
import Alamofire

protocol AuthServiceFactory: AuthServiceDependecy {
    func authProvider() -> AuthNetworkProtocol
}
protocol AuthServiceDependecy: ServiceDependency {
    var userSession: UserSessionManager { get }
}

extension AuthServiceFactory {
    func authProvider() -> AuthNetworkProtocol {
        
        #if MOCK

        MockServerService.shared.setupAuth()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: config)
        
        return NetworkService(session: session)
        
        #else
        
        return NetworkService()
        
        #endif
    }
}
