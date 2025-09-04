//
//  AppCoordinator.swift
//  SportsCommunity
//
//  Created by Илья Макаров on 17.01.2025.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

final class AppCoordinator: Coordinator {

    private let window: UIWindow
    private let userSession: UserSession
    private let serviceFactory: ServiceFactory
    
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
        self.userSession = UserSession()
        self.serviceFactory = ServiceFactory(userSession: self.userSession)
    }
    
    func start() {
        self.userSession.delegate = self
        
        var network = serviceFactory.networkMonitoring
        network.delegate = self
        network.startMonitoring()
        
        startSplashScreen()
        
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func startSplashScreen() {
        let router = SplashScreenRouter()
        router.delegate = self
        let viewModel = SplashScreenViewModel(router: router, serviceFactory: serviceFactory)
        let viewController = SplashScreenViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func startAuthFlow() {
        let authCoordinator = AuthCoordinator(serviceFactory: serviceFactory)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        window.rootViewController = authCoordinator.navigationController
        authCoordinator.start()
    }
    
    func startMainFlow() {
        let mainCoordinator = MainCoordinator(serviceFactory: serviceFactory)
        childCoordinators.append(mainCoordinator)
        window.rootViewController = mainCoordinator.tabBarController
        mainCoordinator.start()
    }
}

extension AppCoordinator: SplashScreenRouterDelegate {
    func goToAuthFlow() {
        self.startAuthFlow()
    }
    
    func goToMainFlow() {
        self.startMainFlow()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didFinishSuccessAuth() {
        if let authCoordinator = childCoordinators.first(where: { $0 is AuthCoordinator}) {
            childCoordinators = childCoordinators.filter { $0 !== authCoordinator }
        }
        self.startMainFlow()
    }
}

extension AppCoordinator: UserSessionDelegate {
    func didSessionExpire() {
        startAuthFlow()
    }
}

extension AppCoordinator: NetworkMonitorDelegate {
    func networkStatusDidChange(isConnected: Bool) {
        // TODO: Сделать всплывающий компонент
        print("networkStatusDidChange: isConnected = \(isConnected)")
    }
}
