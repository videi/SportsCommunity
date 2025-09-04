//
//  CodeInputViewModel.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 21.01.2025.
//

import Foundation
import SwiftKeychainWrapper

final class CodeInputViewModel {
    
    // MARK: - Properties
    
    private let router: CodeInputRouter
    
    private let authService: AuthNetworkProtocol
    private let userSession: UserSessionManager
    private var requestID: String
    private let phoneNumber : String
    
    private var retryAttempts : Int
    private let totalSeconds : Int
    private var timer: Timer?
    private(set) var remainingSeconds: Int {
        didSet {
            onRemainingSecondsUpdate?(remainingSeconds)
        }
    }
    
    // MARK: - Closure
    
    var onRemainingSecondsUpdate: ((Int) -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onNotify: ((_ message: String, _ completion: @escaping () -> Void) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Init
    
    init(requestID: String, 
         phoneNumber: String,
         authService: AuthNetworkProtocol,
         userSession: UserSessionManager,
         router: CodeInputRouter) {
        self.router = router
        
        self.requestID = requestID
        self.phoneNumber = phoneNumber
        self.authService = authService
        self.userSession = userSession
        
        retryAttempts = 2
        totalSeconds = 5
        remainingSeconds = totalSeconds
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Method
    
    func getCodeAgain() {
        
        onLoading?(true)
        
        authService.sendPhoneNumber(phoneNumber: self.phoneNumber) { [weak self] result in
            guard let self = self else { return }
            
            self.onLoading?(false)
            
            switch result {
            case .success(let response):
                self.requestID = response.requestId
                self.startTimer()
            case .failure(let error):
                self.onError?("Не удалось отправить номер телефона")
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func checkCode(_ code: String) {
        
        onLoading?(true)
        
        let authCodeRequest = AuthCodeRequest(requestId: requestID, code: code, phone: phoneNumber)
        
        authService.sendSMSCode(authCodeRequest: authCodeRequest) { [weak self] result in
            guard let self = self else { return }
            
            self.onLoading?(false)
            
            switch result {
            case .success(let token):
                self.userSession.tokenManager.saveTokens(accessToken: token.accessToken, 
                                                         refreshToken: token.refreshToken)
                timer?.invalidate()
                self.router.goToMain()
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    if case .clientError(let message) = networkError {
                        self.onNotify?(message) {
                            if self.retryAttempts <= 0 {
                                self.router.goBack()
                            }
                            self.retryAttempts -= 1
                        }
                    } else {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func startTimer() {
        
        timer?.invalidate()
        
        remainingSeconds = totalSeconds
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            remainingSeconds -= 1
            if remainingSeconds <= 0 {
                timer.invalidate()
            }
        }
    }
}
