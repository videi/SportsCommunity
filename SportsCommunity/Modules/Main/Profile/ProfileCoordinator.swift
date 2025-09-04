//
//  ProfileCoordinator.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 14.08.2025.
//

import Foundation
import UIKit

final class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []

    let profileService: ProfileNetworkProtocol
    let userSessionManager: UserSessionManager
    
    init(navigationController: UINavigationController, mainServiceFactory: MainServiceFactory) {
        self.navigationController = navigationController
        self.profileService = mainServiceFactory.profileProvider()
        self.userSessionManager = mainServiceFactory.userSession
    }
    
    deinit {
        
    }
    
    func start() {
        let router = ProfileRouter()
        router.delegate = self
        let viewModel = ProfileViewModel(profileService: self.profileService, router: router)
        let viewController = ProfileViewController(viewModel: viewModel)
        self.navigationController.setViewControllers([viewController], animated: false)
    }
}

extension ProfileCoordinator: ProfileRouterDelegate {
    func goToEdit(user: User) {
        let router = ProfileEditRouter()
        router.delegate = self
        let viewModel = ProfileEditViewModel(user: user, profileService: self.profileService, router: router, userSessionManager: self.userSessionManager)
        let viewController = ProfileEditViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(viewController, animated: true)
    }
} 

extension ProfileCoordinator: ProfileEditRouterDelegate {
    func didCancelEditProfile() {
        self.navigationController.popViewController(animated: true)
    }
    
    func didSaveEditProfile(updatedUser: User) {
        self.navigationController.viewControllers
            .compactMap { $0 as? ProfileViewController }
            .first?
            .updateUserInfo(user: updatedUser)
        self.navigationController.popViewController(animated: true)
    }
}
