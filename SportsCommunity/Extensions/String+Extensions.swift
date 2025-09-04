//
//  String+Extension.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 20.08.2025.
//

import Foundation

extension String? {
    func toDate(format: String = "yyyy-MM-dd") throws -> Date? {
        if let dateStr = self, !dateStr.isEmpty {
            
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = TimeZone(secondsFromGMT: 0)

            if let date = formatter.date(from: dateStr) {
                return date
            } else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: "Cannot convert '\(dateStr)' to date with format \(format)"
                    )
                )
            }
            
        } else {
            return nil
        }
    }
    
    func toDate(style: DateFormatter.Style) throws -> Date? {
        if let dateStr = self, !dateStr.isEmpty {
            
            let formatter = DateFormatter()
            formatter.dateStyle = style
            formatter.timeZone = TimeZone(secondsFromGMT: 0)

            if let date = formatter.date(from: dateStr) {
                return date
            } else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: "Cannot convert '\(dateStr)' to date with style \(style)"
                    )
                )
            }
            
        } else {
            return nil
        }
    }
    
    func toPhoneNumber() throws -> String {
        guard let self else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Cannot convert empty string to phone number format"
                )
            )
        }
        
        var digits = self.filter { $0.isNumber }
        
        if digits.first == "8" || digits.first == "7" {
            digits.removeFirst()
        }
        
        guard digits.count == 10 else {
            return self
        }
        
        return "+7 \(digits.prefix(3)) " +
               "\(digits.dropFirst(3).prefix(3))-" +
               "\(digits.dropFirst(6).prefix(2))-" +
               "\(digits.dropFirst(8).prefix(2))"
    }
}

extension String {
    func convertDateString(inputFormt: String = "d MMM yyyy", outputFormat: String = "yyyy-MM-dd", locale: Locale = .current) throws -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = locale
        inputFormatter.dateFormat = inputFormt
        
        guard let date = inputFormatter.date(from: self) else {
            throw DateConversionError.invalidInputFormat
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = locale
        outputFormatter.dateFormat = outputFormat
        let result = outputFormatter.string(from: date)
        
        guard !result.isEmpty else {
            throw DateConversionError.invalidOutputFormat
        }
        
        return result
    }
    
    enum DateConversionError: Error {
        case invalidInputFormat
        case invalidOutputFormat
    }
    
    func toDate(format: String = "yyyy-MM-dd") throws -> Date {
        if !self.isEmpty {
            
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = TimeZone(secondsFromGMT: 0)

            if let date = formatter.date(from: self) {
                return date
            } else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: "Cannot convert '\(self)' to date with format \(format)"
                    )
                )
            }
            
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Cannot convert empty string to date with format \(format)"
                )
            )
        }
    }
    
    func toDate(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) throws -> Date {
        if !self.isEmpty {
            
            let formatter = DateFormatter()
            formatter.dateStyle = dateStyle
            formatter.timeStyle = timeStyle
            formatter.timeZone = TimeZone(secondsFromGMT: 0)

            if let date = formatter.date(from: self) {
                return date
            } else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: "Cannot convert '\(self)' to date with date style \(dateStyle.rawValue), time style \(timeStyle.rawValue)"
                    )
                )
            }
            
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Cannot convert empty string to date with date style \(dateStyle.rawValue), time style \(timeStyle.rawValue)"
                )
            )
        }
    }
}

extension String {
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
