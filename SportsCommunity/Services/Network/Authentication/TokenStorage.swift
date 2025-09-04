//
//  TokenManager.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 30.01.2025.
//

import Foundation
import SwiftKeychainWrapper

public protocol TokenManager {
    func getToken() -> TokenModel?
    func saveTokens(accessToken: String, refreshToken: String)
    func updateTokens(accessToken: String, refreshToken: String)
    func clearTokens()
}

final internal class TokenStorage: TokenManager {
    
    // MARK: - Constants
    private enum Constants {
        static let accessTokenKey = "accessToken"
        static let refreshTokenKey = "refreshToken"
    }
    
    init() {}
    
    // MARK: - Properties
    private let keychainWrapper = KeychainWrapper.standard
    
    // MARK: - Public Methods
    
    /// Получение токенов
    func getToken() -> TokenModel? {
        guard let accessToken = keychainWrapper.string(forKey: Constants.accessTokenKey),
              let refreshToken = keychainWrapper.string(forKey: Constants.refreshTokenKey) else {
            return nil
        }
        
        return TokenModel(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    /// Сохранение токенов
    func saveTokens(accessToken: String, refreshToken: String) {
        keychainWrapper.set(accessToken, forKey: Constants.accessTokenKey)
        keychainWrapper.set(refreshToken, forKey: Constants.refreshTokenKey)
    }
    
    /// Удаление всех токенов
    func clearTokens() {
        keychainWrapper.removeObject(forKey: Constants.accessTokenKey)
        keychainWrapper.removeObject(forKey: Constants.refreshTokenKey)
    }
    
    /// Обновление токенов
    func updateTokens(accessToken: String, refreshToken: String) {
        clearTokens()
        saveTokens(accessToken: accessToken, refreshToken: refreshToken)
    }
}

public struct TokenModel {
    let accessToken: JWTToken
    let refreshToken: JWTToken
    
    init(accessToken: String, refreshToken: String) {
        self.accessToken = JWTToken(value: accessToken)
        self.refreshToken = JWTToken(value: refreshToken)
    }
}

internal struct JWTToken {
    let value: String
    
    var expirationDate: Date {
        Date(timeIntervalSince1970: payload?.exp ?? 0)
    }
    var isValid: Bool {
        Date(timeIntervalSinceNow: 60 * 5) > expirationDate
    }
    private var payload: JWTPayload? {
        decode(jwtToken: value)
    }
    
    init(value: String) {
        self.value = value
    }
    
    // MARK: - JWT Decoding
    private func decode(jwtToken jwt: String) -> JWTPayload? {
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            
            while base64.count % 4 != 0 {
                base64 += "="
            }
            
            return Data(base64Encoded: base64)
        }
        
        let segments = jwt.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }
        
        let payloadSegment = segments[1]
        
        guard let payloadData = base64UrlDecode(payloadSegment),
              let payload = try? JSONDecoder().decode(JWTPayload.self, from: payloadData) else {
            return nil
        }
        
        return payload
    }
}

private struct JWTPayload: Codable {
    let exp: TimeInterval
    let iat: TimeInterval?
    let sub: String?
}
