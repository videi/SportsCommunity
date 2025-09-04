//
//  Task+Extensions.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 22.08.2025.
//

import Foundation

extension Task where Success == Never, Failure == Never  {
    static func sleep(milliseconds: UInt64) async throws {
        try await Task.sleep(nanoseconds: milliseconds * 1_000_000)
    }
    
    static func sleep(seconds: UInt64) async throws {
        try await Task.sleep(nanoseconds: seconds * 1_000_000_000)
    }
}
