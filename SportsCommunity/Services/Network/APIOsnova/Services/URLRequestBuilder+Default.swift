//
//  URLFactory.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 27.01.2025.
//

import Foundation
import Alamofire
import UIKit

extension URLRequestBuilder {
    var baseURL: String {
        "https://api.app-osnova.ru" // TODO: Сделать через .xconfig
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString, forHTTPHeaderField: "X-Device-Id")
        request.setValue(UIDevice.current.model, forHTTPHeaderField: "X-Device-Type")
        request.allHTTPHeaderFields = headers?.dictionary
        request = try encoding.encode(request, with: parameters)
        
        return request
    }
}
