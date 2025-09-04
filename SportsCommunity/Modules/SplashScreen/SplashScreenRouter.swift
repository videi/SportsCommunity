//
//  SplashScreenRouter.swift
//  ApplicationName
//
//  Created by Илья Макаров on 14.02.2025
//

import Foundation

protocol SplashScreenRouterDelegate: AnyObject {
    func goToAuthFlow()
    func goToMainFlow()
}

final class SplashScreenRouter {
    weak var delegate: SplashScreenRouterDelegate?
    
    func goToAuthFlow() {
        delegate?.goToAuthFlow()
    }
    func goToMainFlow() {
        delegate?.goToMainFlow()
    }
}
