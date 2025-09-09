//
//  AuthCoordinator.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 20.01.2025.
//

import Foundation
import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func didFinishSuccessAuth()
}

final class AuthCoordinator: Coordinator {
    
    // TODO: Replace navigatorController on router
    
    var delegate: AuthCoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    let authServiceFactory: AuthServiceFactory
    
    init(serviceFactory: AuthServiceFactory) {
        self.navigationController = UINavigationController()
        self.authServiceFactory = serviceFactory
    }
    
    deinit {
        print("AuthCoordinator deinit")
    }
    
    func start() {
        let router = PhoneInputRouter()
        router.delegate = self
        let viewModel = PhoneInputViewModel(router: router, authService: authServiceFactory.authProvider())
        let viewController = PhoneInputViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension AuthCoordinator: PhoneInputRouterDelegate {
    func goToCodeInput(phoneNumber: String, requestID: String) {
        let router = CodeInputRouter()
        router.delegate = self
        let viewModel = CodeInputViewModel(requestID: requestID, 
                                           phoneNumber: phoneNumber,
                                           authService: self.authServiceFactory.authProvider(),
                                           userSession: self.authServiceFactory.userSession,
                                           tokenManager: self.authServiceFactory.tokenManager,
                                           router: router)
        let viewController = CodeInputViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension AuthCoordinator: CodeInputRouterDelegate {
    func didAttemptsAreOver() {
        self.navigationController.popViewController(animated: true)
    }
    
    func didFinishSuccessAuth() {
        delegate?.didFinishSuccessAuth()
    }
}
