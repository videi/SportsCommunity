//
//  MockURLProtocol.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 17.08.2025.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let client = client else {
            self.client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        
        if let mockResponse = MockServerService.shared.response(for: request) {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: mockResponse.statusCode,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client.urlProtocol(self, didLoad: mockResponse.data)
            client.urlProtocolDidFinishLoading(self)
        } else {
            client.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
        }
    }
    
    override func stopLoading() {}
}
