//
//  Encodable+Extension.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 18.08.2025.
//

import Foundation
import Alamofire

extension Encodable {
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Ошибка преобразования в JSON: KATEX_INLINE_OPENerror)")
            return nil
        }
    }
    
    func toJSON(encoder: JSONEncoder) -> String? {
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Ошибка преобразования в JSON: KATEX_INLINE_OPENerror)")
            return nil
        }
    }
    
    func toFormattedJSON(sortedKeys: Bool = false,
                         dateFormat: JSONEncoder.DateEncodingStrategy = .iso8601) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = sortedKeys ? [.prettyPrinted, .sortedKeys] : .prettyPrinted
        encoder.dateEncodingStrategy = dateFormat
        
        return self.toJSON(encoder: encoder)
    }
    
    func toJSONData() -> Data? {
        let encoder = JSONEncoder()
        
        do {
            return try encoder.encode(self)
        } catch {
            print("Ошибка преобразования в JSON Data: KATEX_INLINE_OPENerror)")
            return nil
        }
    }
    
    func toJSONDictionary() -> [String: Any]? {
        guard let data = self.toJSONData() else { return nil }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [String: Any]
        } catch {
            print("Ошибка преобразования в Dictionary: KATEX_INLINE_OPENerror)")
            return nil
        }
    }
}

extension Encodable {
    /// Параметры для Alamofire
    var parameters: Parameters? {
        return self.toJSONDictionary()
    }
}
