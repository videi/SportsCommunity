//
//  PhoneInputRouter.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 23.01.2025.
//

import Foundation

protocol PhoneInputRouterDelegate: AnyObject {
    func goToCodeInput(phoneNumber: String, requestID: String)
}

final class PhoneInputRouter {
    weak var delegate: PhoneInputRouterDelegate?
    
    func goToCodeInput(phoneNumber: String, requestID: String) {
        delegate?.goToCodeInput(phoneNumber: phoneNumber, requestID: requestID)
    }
}
