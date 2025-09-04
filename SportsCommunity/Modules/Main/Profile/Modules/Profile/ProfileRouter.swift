//
//  ProfileRouter.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 24.01.2025.
//

import Foundation

protocol ProfileRouterDelegate: AnyObject {
    func goToEdit(user: User)
}

final class ProfileRouter {
    weak var delegate: ProfileRouterDelegate?
    
    func goToEdit(user: User) {
        delegate?.goToEdit(user: user)
    }
}
