//
//  MainCoordinator.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 21.01.2025.
//

import Foundation
import UIKit
import SwiftUI

final class MainCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    lazy var tabBarController = UITabBarController()
    lazy var navigationControllers = MainCoordinator.makeNavigationControllers()
    
    private let mainServiceFactory: MainServiceFactory
    
    init(serviceFactory: MainServiceFactory) {
        self.navigationController = UINavigationController()
        self.mainServiceFactory = serviceFactory
        setupAppearance()
    }
    
    func start() {
        setupProfile()
        setupEvents()
        setupSettings()

        let navigationControllers = MainRouteType.allCases.compactMap {
            self.navigationControllers[$0]
        }
        
        self.tabBarController.setViewControllers(navigationControllers, animated: true)
    }
    
    func setupProfile() {
        guard let navController = self.navigationControllers[.profile] else {
            fatalError("can't find navController")
        }
        
        let profileCoordinator = ProfileCoordinator(navigationController: navController, mainServiceFactory: mainServiceFactory)
        profileCoordinator.start()
        childCoordinators.append(profileCoordinator)
    }
    
    func setupEvents() {
        guard let navController = self.navigationControllers[.events] else {
            fatalError("can't find navController")
        }
        
        let eventsCoordinator = EventsCoordinator(navigationController: navController, eventsService: mainServiceFactory.eventsProvider())
        eventsCoordinator.start()
        childCoordinators.append(eventsCoordinator)
    }
    
    func setupSettings() {
        guard let navController = self.navigationControllers[.settings] else {
            fatalError("can't find navController")
        }
        
        let viewModel = SettingsViewModel()
        let viewController = SettingsViewController(viewModel: viewModel)
        
        navController.setViewControllers([viewController], animated: false)
        viewController.navigationItem.title = MainRouteType.settings.title
        viewController.navigationItem.largeTitleDisplayMode = .inline
    }
    
    static func makeNavigationControllers() -> [MainRouteType: UINavigationController] {
        Dictionary(uniqueKeysWithValues: MainRouteType.allCases.map { route in
                let navigationController = UINavigationController()
                navigationController.tabBarItem = UITabBarItem(
                    title: route.title,
                    image: route.image,
                    tag: route.rawValue
                )
                navigationController.navigationBar.prefersLargeTitles = true
                return (route, navigationController)
            })
    }
        
    func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor(hex: "#F2F2F2")
            
            appearance.largeTitleTextAttributes = [
                .font: FontFamily.HelveticaNeue.bold.font(size: 32),
                .foregroundColor: UIColor.black
            ]
            
            UINavigationBar.appearance().tintColor = .black
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().barTintColor = .purple
            UINavigationBar.appearance().isTranslucent = false
        }
        
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UITabBar.appearance().backgroundColor = UIColor(hex: "#F2F2F2")
        UITabBar.appearance().tintColor = UIColor(hex: "#7950F3")
    }
}

enum MainRouteType: Int, CaseIterable {
    case profile, events, settings
    
    var title: String {
        switch self {
        case .profile:
            return L10n.Main.Profile.title
        case .events:
            return L10n.Main.Events.title
        case .settings:
            return L10n.Main.Settings.title
        }
    }
    
    var image: UIImage? {
        switch self {
        case .profile:
            return Asset.Assets.MainTabBar.profile.image
        case .events:
            return Asset.Assets.MainTabBar.events.image
        case .settings:
            return Asset.Assets.MainTabBar.settings.image
        }
    }
}
