//
//  InputStream+Extension.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 20.08.2025.
//

import Foundation

extension InputStream {
    func readAllData(bufferSize: Int = 1024) -> Data {
        var data = Data()
        var buffer = [UInt8](repeating: 0, count: bufferSize)

        self.open()
        defer { self.close() }

        while self.hasBytesAvailable {
            let bytesRead = self.read(&buffer, maxLength: buffer.count)
            if bytesRead < 0 {
                // Ошибка чтения
                break
            } else if bytesRead == 0 {
                // Конец потока
                break
            } else {
                data.append(buffer, count: bytesRead)
            }
        }

        return data
    }
}
