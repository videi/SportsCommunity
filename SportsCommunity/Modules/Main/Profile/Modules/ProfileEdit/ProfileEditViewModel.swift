//
//  ProfileEditViewModel.swift
//  ApplicationName
//
//  Created by Илья Макаров on 14.08.2025
//

import Foundation

final class ProfileEditViewModel {
    
    // MARK: - Fields

    private let router: ProfileEditRouter
    private let profileService: ProfileNetworkProtocol
    private let userSessionManager: UserSessionManager
    
    let user: User
    
    // MARK: - Closure
    
    var onNotify: ((_ message: String, _ completion: @escaping () -> Void) -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    // MARK: - Init
    
    init(user: User, profileService: ProfileNetworkProtocol, router: ProfileEditRouter, userSessionManager: UserSessionManager) {
        self.user = user
        self.profileService = profileService
        self.router = router
        self.userSessionManager = userSessionManager
    }
    
    // MARK: - Method
    
    func save(name: String, surname: String, birthday: String, email: String) {
        
        onLoading?(true)
        
        let result = Result {
            try birthday.convertDateString()
        }
            .map { formattedBirthday in
                UserAPI.Request.Update(
                    id: String(user.id),
                    name: name,
                    surname: surname,
                    email: email,
                    birthday: formattedBirthday
                )
            }
        
        switch result {
        case .success(let request):
            profileService.updateUserData(user: request) { [weak self] result in
                guard let self else { return }
                self.onLoading?(false)
                
                result
                    .flatMap { dto in Result { try User(from: dto) } }
                    .onSuccess { user in
                        self.router.didSaveEditProfile(updatedUser: user)
                    }
                    .onError { error in
                        self.handleError(error)
                    }
            }
            
        case .failure(let error):
            onLoading?(false)
            handleError(error)
        }
    }
    
    func cancel() {
        self.router.didCancelEditProfile()
    }
    
    func exitProfile() {
        self.userSessionManager.logout()
    }
    
    func validateInputs() -> Bool {
        //TODO: Проверка модели данных перед отправкой на сервер
//        guard let email = emailTextField.text, email.isValidEmail else {
//            return false
//        }
        return true
    }
    
    private func handleError(_ error: Error) {
        print(error.localizedDescription)
        onError?(L10n.Message.Profile.Edit.failure)
    }
}
