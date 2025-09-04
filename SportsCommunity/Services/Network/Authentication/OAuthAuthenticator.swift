//
//  OAuthAuthenticator.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 07.02.2025.
//

import Foundation
import Alamofire

final class OAuthAuthenticator: Authenticator {
    
    private let userSession: UserSessionManager
    
    init(userSession: UserSessionManager) {
        self.userSession = userSession
    }
    
    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.token.accessToken.value))
    }
    
    func refresh(_ credential: OAuthCredential,
                 for session: Session,
                 completion: @escaping (Result<OAuthCredential, Error>) -> Void) {
        
        NetworkService().refreshAuthToken(refreshToken: credential.token.refreshToken.value) { response in
            switch response {
            case .success(let tokenResponse):
                let newCredential = OAuthCredential(token: TokenModel(
                    accessToken: tokenResponse.accessToken,
                    refreshToken: tokenResponse.refreshToken))
                
                self.userSession.tokenManager.saveTokens(accessToken: tokenResponse.accessToken,
                                                         refreshToken: tokenResponse.refreshToken)
                
                completion(.success(newCredential))
            case .failure(let error):
                self.userSession.logout()
                completion(.failure(error))
            }
        }
    }
    
    func didRequest(_ urlRequest: URLRequest,
                    with response: HTTPURLResponse,
                    failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }
    
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.token.accessToken.value).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
}


public struct OAuthCredential: AuthenticationCredential {
    private let timeIntervalForRefresh: TimeInterval = 60 * 5
    
    let token: TokenModel

    // Require refresh if within 5 minutes of expiration
    public var requiresRefresh: Bool {
        Date(timeIntervalSinceNow: timeIntervalForRefresh) > token.accessToken.expirationDate
    }
}
