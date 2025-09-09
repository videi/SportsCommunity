//
//  ProfileViewModel.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 05.11.2024.
//

import Foundation
import SwiftKeychainWrapper

protocol ProfileModuleInput: AnyObject {
    func userUpdated(_ user: User)
}

extension ProfileViewModel: ProfileModuleInput {
    func userUpdated(_ user: User) {
        self.user = user
    }
}

public class ProfileViewModel {
    
    //MARK: - Fields
    
    private let profileNetworkService: ProfileNetworkProtocol
    
    let router: ProfileRouter
    var user: User? {
        didSet {
            if let profile = user {
                if onUpdate != nil {
                    onUpdate?(profile)
                }
            }
        }
    }
    
    //MARK: - Closure
    
    var onNotify: ((_ message: String, _ completion: @escaping () -> Void) -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onUpdate: ((User) -> Void)?
    
    // MARK: - Init
    
    init(profileService: ProfileNetworkProtocol, router: ProfileRouter) {
        self.profileNetworkService = profileService
        self.router = router
    }
    
    //MARK: - Methods
    
    func loadProfileInfo() {
        
        self.onLoading?(true)
        
        profileNetworkService.getProfile() { [weak self] result in
            guard let self = self else { return }
            
            self.onLoading?(false)
            
            switch result {
            case .success(let profileDTO): 
                print("Profile: \(profileDTO)")
                
                do {
                    self.user = try User(from: profileDTO.user)
                } catch (let error) {
                    print("\(error.localizedDescription)")
                    self.onError?(L10n.Message.Profile.Load.failure)
                }

            case .failure(let error):
                print("\(error.localizedDescription)")
                self.onError?(L10n.Message.Profile.Load.failure)
            }
        }        
    }
    
    func loadProfileInfoAsync() async {
        self.onLoading?(true)
        
        do {
            let profileDTO = try await profileNetworkService.getProfileAsync()
            let user = try User(from: profileDTO.user)
            self.user = user
            print("Profile:", user)
        } catch (let error) {
            //TODO: Loging error
            print("\(error.localizedDescription)")
            self.onError?(L10n.Message.Profile.Load.failure)
        }
        
        self.onLoading?(false)
    }
    
    func editProfile() {
        guard let user = self.user else { return }
        self.router.goToEdit(user: user)
    }
}
