//
//  ProfileEditRouter.swift
//  ApplicationName
//
//  Created by Илья Макаров on 14.08.2025
//

import Foundation

protocol ProfileEditRouterDelegate: AnyObject {
    func didSaveEditProfile(updatedUser: User)
    func didCancelEditProfile()
}

final class ProfileEditRouter {
    weak var delegate: ProfileEditRouterDelegate?
    
    func didCancelEditProfile() {
        delegate?.didCancelEditProfile()
    }
    
    func didSaveEditProfile(updatedUser: User) {
        delegate?.didSaveEditProfile(updatedUser: updatedUser)
    }
}
