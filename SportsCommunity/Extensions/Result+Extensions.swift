//
//  Result+Extensions.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 22.08.2025.
//

import Foundation

extension Result {
    @discardableResult
    func onSuccess(_ body: (Success) -> Void) -> Self {
        if case .success(let value) = self { body(value) }
        return self
    }

    @discardableResult
    func onError(_ body: (Failure) -> Void) -> Self {
        if case .failure(let error) = self { body(error) }
        return self
    }
}
