//
//  CodeInputRouter.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 24.01.2025.
//

import Foundation

protocol CodeInputRouterDelegate: AnyObject {
    func didFinishSuccessAuth()
    func didAttemptsAreOver()
}

final class CodeInputRouter {
    weak var delegate: CodeInputRouterDelegate?
    
    func goToMain() {
        delegate?.didFinishSuccessAuth()
    }
    
    func goBack() {
        delegate?.didAttemptsAreOver()
    }
}
