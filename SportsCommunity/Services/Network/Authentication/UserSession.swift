//
//  UserSession.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 06.02.2025.
//

import Foundation

public protocol UserSessionDelegate: AnyObject {
    func didSessionExpire()
}

public protocol UserSessionManager: Sendable {
    var isAuthenticated: Bool { get }
    
    func getCredential() -> OAuthCredential?
    func logout()
}

final class UserSession: UserSessionManager, @unchecked Sendable {
    
    weak var delegate: UserSessionDelegate?
    private var tokenManager: TokenManager
    
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    
    var isAuthenticated: Bool {
        guard let token = tokenManager.getToken() else {
            return false
        }
        return token.refreshToken.isValid
    }
    
    func getCredential() -> OAuthCredential? {
        guard let token = tokenManager.getToken() else {
            return nil
        }
        
        return OAuthCredential(token: token)
    }
    
    func logout() {
        tokenManager.clearTokens()
        DispatchQueue.main.async {
            self.delegate?.didSessionExpire()
        }
    }
}
