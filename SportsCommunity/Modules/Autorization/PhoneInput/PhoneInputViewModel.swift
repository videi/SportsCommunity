//
//  PhoneNumberViewModel.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 21.01.2025.
//

import Foundation

final class PhoneInputViewModel {
    
    // MARK: - Properties
    
    private let router: PhoneInputRouter
    private let authService: AuthNetworkProtocol
    
    // MARK: - Closure
    
    var onNotify: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    // MARK: - Init
    
    init(router: PhoneInputRouter, authService: AuthNetworkProtocol) {
        
        self.router = router
        self.authService = authService
    }
    
    // MARK: - Method
    
    func formatPhoneNumber(_ phoneNumber: String?) -> String {
        
        let originalText = phoneNumber ?? ""
        
        let digits = originalText.replacingOccurrences(of: "+7 ", with: "").filter { "0123456789".contains($0) }
        
        let formattedText: String
        switch digits.count {
        case 0...3:
            formattedText = digits
        case 4...6:
            formattedText = "(\(digits.prefix(3))) \(digits.dropFirst(3))"
        case 7...10:
            formattedText = "(\(digits.prefix(3))) \(digits.dropFirst(3).prefix(3))-\(digits.dropFirst(6))"
        default:
            formattedText = "(\(digits.prefix(3))) \(digits.dropFirst(3).prefix(3))-\(digits.dropFirst(6).prefix(4))"
        }
        
        return formattedText
    }
    
    func submitPhoneNumber(_ phoneNumber: String?) {
        
        let phoneDigits = phoneNumber?.replacingOccurrences(of: "+7 ", with: "").filter { "0123456789".contains($0) }
        
        guard let digits = phoneDigits, !digits.isEmpty else {
            self.onNotify?(L10n.Message.PhoneNumber.empty)
            return
        }
        
        let phoneRegex = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        if phoneTest.evaluate(with: phoneDigits) {
            print("phone number is valid")
        } else {
            self.onNotify?(L10n.Message.PhoneNumber.wrong)
            return
        }
        
        onLoading?(true)
        
        let verifyPhoneNumber = "+7\(phoneDigits!)"
        
        authService.sendPhoneNumber(phoneNumber: verifyPhoneNumber) { [weak self] result in
            guard let self = self else { return }
            
            self.onLoading?(false)
            
            switch result {
            case .success(let response):
                let requestID = response.requestId
                print("success \(requestID)")
                self.router.goToCodeInput(phoneNumber: verifyPhoneNumber, requestID: requestID)
            case .failure(let error):
                print("failed to send phone number.\(error.localizedDescription)")
                self.onError?(L10n.Message.Service.error)
            }
        }
    }
}
