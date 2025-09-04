//
//  Decodable+Extension.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 19.08.2025.
//

import Foundation

extension Decodable {
    // Из JSON строки
    func fromJSON(_ jsonString: String) -> Self? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Ошибка преобразования строки в Data")
            return nil
        }
        
        return fromJSON(jsonData)
    }
    
    // Из Data
    func fromJSON(_ jsonData: Data) -> Self? {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(Self.self, from: jsonData)
        } catch {
            print("Ошибка декодирования JSON: KATEX_INLINE_OPENerror)")
            return nil
        }
    }
    
    // Из Dictionary
    func fromJSON(_ dictionary: [String: Any]) -> Self? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
            return fromJSON(jsonData)
        } catch {
            print("Ошибка преобразования Dictionary в Data: KATEX_INLINE_OPENerror)")
            return nil
        }
    }
    
    // С кастомным декодером
    func fromJSON(_ jsonData: Data, decoder: JSONDecoder) -> Self? {
        do {
            return try decoder.decode(Self.self, from: jsonData)
        } catch {
            print("Ошибка декодирования JSON: KATEX_INLINE_OPENerror)")
            return nil
        }
    }
}
