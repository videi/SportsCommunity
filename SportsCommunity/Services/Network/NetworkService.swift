//
//  NetworkService.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 21.01.2025.
//

import Foundation
import Alamofire

public protocol URLRequestBuilder: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

public final class NetworkService {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    public func baseRequest<T: Decodable>(convertible: URLRequestBuilder, completion: @escaping (Result<T, Error>) -> Void) {
        guard URL(string: convertible.baseURL) != nil else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        session.request(convertible)
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    if let data = response.data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            
                            switch statusCode {
                            case 401: completion(.failure(NetworkError.unauthorized))
                            case 400...499: completion(.failure(NetworkError.clientError(errorResponse.reason)))
                            case 500...599: completion(.failure(NetworkError.serverError(errorResponse.reason)))
                            default: completion(.failure(NetworkError.networkError(error)))
                            }
                            
                        } catch {
                            completion(.failure(NetworkError.decodingError(String(data: data, encoding: .utf8) ?? "Invalid UTF8 data")))
                        }
                        
                    } else {
                        completion(.failure(NetworkError.noData(error)))
                    }
                } else {
                    completion(.failure(NetworkError.networkError(error)))
                }
            }
        }
    }
    
    public func baseRequest(convertible: URLRequestBuilder, completion: @escaping (Result<Void, Error>) -> Void) {
        guard URL(string: convertible.baseURL) != nil else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        session.request(convertible)
        .validate()
        .response() { response in
            switch response.result {
            case .success(let value):
                completion(.success(()))
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    if let data = response.data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            
                            switch statusCode {
                            case 401: completion(.failure(NetworkError.unauthorized))
                            case 400...499: completion(.failure(NetworkError.clientError(errorResponse.reason)))
                            case 500...599: completion(.failure(NetworkError.serverError(errorResponse.reason)))
                            default: completion(.failure(NetworkError.networkError(error)))
                            }
                            
                        } catch {
                            completion(.failure(NetworkError.decodingError(String(data: data, encoding: .utf8) ?? "Invalid UTF8 data")))
                        }
                        
                    } else {
                        completion(.failure(NetworkError.noData(error)))
                    }
                } else {
                    completion(.failure(NetworkError.networkError(error)))
                }
            }
        }
    }
    
    public func baseRequest<T: Decodable>(convertible: URLRequestBuilder) async throws -> T {
        guard URL(string: convertible.baseURL) != nil else {
            throw NetworkError.invalidURL
        }
        
        let response = await session.request(convertible)
            .validate()
            .serializingData()
            .response
        
        guard let statusCode = response.response?.statusCode else {
            throw NetworkError.networkError(response.error ?? AFError.explicitlyCancelled)
        }
        
        switch (response.result) {
        case .success(let data):
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(String(data: data, encoding: .utf8) ?? "Invalid UTF8 data")
            }
        case .failure(let error):
            guard let data = response.data else {
                throw NetworkError.noData(error)
            }
            
            do {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                switch statusCode {
                case 401: throw NetworkError.unauthorized
                case 400...499: throw NetworkError.clientError(errorResponse.reason)
                case 500...599: throw NetworkError.serverError(errorResponse.reason)
                default: throw NetworkError.networkError(error)
                }
            } catch {
                throw NetworkError.decodingError(String(data: data, encoding: .utf8) ?? "Invalid UTF8 data")
            }
        }
    }
}

public enum NetworkError: Error {
    case invalidURL
    case unauthorized
    case decodingError(String)
    case noData(Error)
    case clientError(String)
    case serverError(String)
    case networkError(Error)
    case unknownError
}

struct ErrorResponse: Decodable {
    let error: Bool
    let reason: String
}
