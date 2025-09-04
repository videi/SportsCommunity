//
//  MockServerService.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 17.08.2025.
//

import Foundation

struct MockResponse {
    let statusCode: Int
    let data: Data
}

final class MockServerService {
    static let shared = MockServerService()
    
    private var profile: ProfileAPI.Model
    private var user: UserAPI.Model
    private var events: [EventAPI.Model] = []
    
    private init() {
        user = UserAPI.Model(id: "1",
                       accountStatus: .pending,
                       phone: "1112223344",
                       name: "Иван",
                       surname: "Иванов",
                       email: "ivan.ivanov@gmail.com",
                       birthday: "1990-01-01")
        profile = ProfileAPI.Model(user: user, onboardingFinished: true)
        
        let calendar = Calendar.current
        let now = Date()
        events = [
            EventAPI.Model(id: 1, name: "Наша игра", participants: 10, maxParticipants: 20, date: now.toString(format: "yyyy-MM-dd HH:mm"), address: "г. Москва", sportType: SportType.football.rawValue),
            EventAPI.Model(id: 2, name: "Группа мастеров", participants: 5, maxParticipants: 15, date: calendar.date(byAdding: .day, value: 1, to: now)!.toString(format: "yyyy-MM-dd HH:mm"), address: "г. Москва", sportType: SportType.hockey.rawValue),
            EventAPI.Model(id: 3, name: "Начинающие", participants: 12, maxParticipants: 12, date: calendar.date(byAdding: .day, value: 3, to: now)!.toString(format: "yyyy-MM-dd HH:mm"), address: "г. Москва", sportType: SportType.volleyball.rawValue),
        ]
    }
    
    private var responses: [String: (URLRequest) -> MockResponse?] = [:]
    
    func registerMock(url: String, json: String) {
        responses[url] = { _ in
            MockResponse(statusCode: 200, data: Data(json.utf8) )
        }
    }
    
    func registerMock(url: String, handler: @escaping (URLRequest) -> MockResponse?) {
        responses[url] = handler
    }
    
    func unregisterMock(url: String) {
        responses.removeValue(forKey: url)
    }
    
    func clear() {
        responses.removeAll()
    }
    
    func response(for request: URLRequest) -> MockResponse? {
        guard let url = request.url?.absoluteString else { return nil }
        return responses[url]?(request)
    }
}

extension MockServerService {
    func setupAuth() {
        
        var retryAttempts: Int = 3
        
        registerMock(
            url: "https://api.app-osnova.ru/api/v1/auth/send-code",
            json: """
                    {
                      "expiresAt": "2025-12-31T23:59:59.891Z",
                      "requestId": "5F77A56B-F84D-4B1C-9FEA-2F81259BB81E",
                      "retryAfter": 60
                    }
                    """
        )
        
        registerMock(
            url: "https://api.app-osnova.ru/api/v1/auth/verify/code",
            json: """
                    {
                      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Mzg2MTEwNTYuODg5NTg0LCJpYXQiOjE3Mzg1MjQ2NTYuODkwMzUwNiwicGgiOiIrNyoqKioqKioxMSIsInN1YiI6IjE2MjgyMjU0LTU4MTYtNEQ5Mi1BNUE1LTkyNUNERDY2RDczNSJ9.wuF5WaWGgzGLTVjGE_fGI58WoUFdtzVfnCjJQYgqN24",
                      "accountStatus": "active",
                      "refreshToken": "HwOdfzwKuWkTXs6c/GLcWSIQfLNlyxQJ8oF3RfUeIKth+hwOMKfHtmQSAyZcJOn0HflScZbc/pARnATlbX+GVRtu+WzWgHQm7EgXSbwxMYRqnlCjrpDLgIBugEyJg7lK3QEBMXTmTQxD9fJM9/NwTGUVbIdurvCrYvTYZX6DloA="
                    }
                    """
        )
        
        registerMock(url: "https://api.app-osnova.ru/api/v1/auth/verify/code") { request in
            if let stream = request.httpBodyStream {
                let data = stream.readAllData()
                print("Got body:", String(data: data, encoding: .utf8) ?? "")
                
                do {
                    let authCodeRequest = try JSONDecoder().decode(AuthCodeRequest.self, from: data)
                    
                    guard authCodeRequest.code == "1111" else {
                        retryAttempts -= 1
                        
                        let errorResponse = """
                        {
                            "error": true,
                            "reason": "Неверено введен код. Осталось попыток \(retryAttempts)"
                        }
                        """
                        return MockResponse(statusCode: 400, data: Data(errorResponse.utf8))
                    }
                    
                    let authTokenResponse = """
                    {
                      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Mzg2MTEwNTYuODg5NTg0LCJpYXQiOjE3Mzg1MjQ2NTYuODkwMzUwNiwicGgiOiIrNyoqKioqKioxMSIsInN1YiI6IjE2MjgyMjU0LTU4MTYtNEQ5Mi1BNUE1LTkyNUNERDY2RDczNSJ9.wuF5WaWGgzGLTVjGE_fGI58WoUFdtzVfnCjJQYgqN24",
                      "accountStatus": "active",
                      "refreshToken": "HwOdfzwKuWkTXs6c/GLcWSIQfLNlyxQJ8oF3RfUeIKth+hwOMKfHtmQSAyZcJOn0HflScZbc/pARnATlbX+GVRtu+WzWgHQm7EgXSbwxMYRqnlCjrpDLgIBugEyJg7lK3QEBMXTmTQxD9fJM9/NwTGUVbIdurvCrYvTYZX6DloA="
                    }
                    """
                    
                    return MockResponse(statusCode: 200, data: Data(authTokenResponse.utf8))
                    
                } catch {
                    print("Ошибка при декодировании: \(error)")
                }
            }
            
            return MockResponse(statusCode: 400, data: Data())
        }
        
        registerMock(
            url: "https://api.app-osnova.ru/api/v1/auth/token/refresh",
            json: """
                    {
                      "accessTokenExpiration": 86400
                      "refreshTokenExpiration": 3888000
                      "refreshToken": "ZXlKMGVYQWlPaUpLVjFRaUxDSmhiR2NpT2lKSVV6STFOaUo5LmV5SnBjM01pT2lJaUxDSnBZWFFpT2pFM05UVTBOVFU0TkRjc0ltVjRjQ0k2TVRjNE5qazVNVGcwTnl3aVlYVmtJam9pSWl3aWMzVmlJam9pSW4wLkRLaXo0QjhWc0NXQWlHTDFGTWFvSVR2cldBb01tTzVIZ0IzbFJBNFNGemc="
                      "accessToken": "ZXlKMGVYQWlPaUpLVjFRaUxDSmhiR2NpT2lKSVV6STFOaUo5LmV5SnBjM01pT2lJaUxDSnBZWFFpT2pFM05UVTBOVFU0TkRjc0ltVjRjQ0k2TVRjNE5qazVNVGcwTnl3aVlYVmtJam9pSWl3aWMzVmlJam9pSW4wLkRLaXo0QjhWc0NXQWlHTDFGTWFvSVR2cldBb01tTzVIZ0IzbFJBNFNGemc="
                    }
                    """
        )
    }
    
    func setupProfile() {
        
        registerMock(
            url: "https://api.app-osnova.ru/api/v1/profile",
            json: profile.toJSON() ?? ""
        )
        
        registerMock(url: "https://api.app-osnova.ru/api/v1/profile/update") { [weak self] request in
            guard let self else {
                return MockResponse(statusCode: 400, data: Data())
            }
            
            if let stream = request.httpBodyStream {
                let data = stream.readAllData()
                print("Got body:", String(data: data, encoding: .utf8) ?? "")
                
                do {
                    let updatedUser = try JSONDecoder().decode(UserAPI.Request.Update.self, from: data)
                    
                    self.user = UserAPI.Model(id: updatedUser.id,
                                              accountStatus: self.user.accountStatus,
                                              phone: self.user.phone,
                                              name: updatedUser.name,
                                              surname: updatedUser.surname,
                                              email: updatedUser.email,
                                              birthday: updatedUser.birthday)
                } catch {
                    print("Ошибка при декодировании: \(error)")
                    return MockResponse(statusCode: 400, data: Data())
                }
            }
            
            guard let ret = self.user.toJSON() else {
                return MockResponse(statusCode: 400, data: Data())
            }
            
            return MockResponse(statusCode: 200, data: Data(ret.utf8))
        }
    }
    
    func setupEvents() {
        registerMock(url: "https://api.app-osnova.ru/api/v1/events") { [weak self] request in
            guard let self else {
                return MockResponse(statusCode: 400, data: Data())
            }
            
            if let jsonData = try? JSONEncoder().encode(events) {
                let ret = String(data: jsonData, encoding: .utf8)
                
                guard let ret = ret else {
                    return MockResponse(statusCode: 400, data: Data())
                }
                
                return MockResponse(statusCode: 200, data: Data(ret.utf8))
            } else {
                print("Ошибка при кодирование")
                return MockResponse(statusCode: 400, data: Data())
            }
        }
        
        registerMock(url: "https://api.app-osnova.ru/api/v1/events/add") { [weak self] request in
            guard let self else {
                return MockResponse(statusCode: 400, data: Data())
            }
            
            if let stream = request.httpBodyStream {
                let data = stream.readAllData()
                print("Got body:", String(data: data, encoding: .utf8) ?? "")
                
                do {
                    let addingEvent = try JSONDecoder().decode(EventAPI.Request.Add.self, from: data)
                    
                    let lastId = events.map({$0.id}).max() ?? 0
                    
                    let newEvent = EventAPI.Model(id: lastId + 1,
                                                  name: addingEvent.name,
                                                  participants: 0,
                                                  maxParticipants: addingEvent.maxParticipants,
                                                  date: addingEvent.date,
                                                  address: addingEvent.address,
                                                  sportType: addingEvent.sportType)
                    events.append(newEvent)
                    
                    guard let ret = EventAPI.Response.Add(id: newEvent.id).toJSON() else {
                        return MockResponse(statusCode: 400, data: Data())
                    }
                    
                    return MockResponse(statusCode: 200, data: Data(ret.utf8))
                    
                } catch {
                    print("Ошибка при декодировании: \(error)")
                    return MockResponse(statusCode: 400, data: Data())
                }
            }
            
            return MockResponse(statusCode: 400, data: Data())
        }
        
        registerMock(url: "https://api.app-osnova.ru/api/v1/events/remove") { [weak self] request in
            guard let self else {
                return MockResponse(statusCode: 400, data: Data())
            }
            
            if let stream = request.httpBodyStream {
                let data = stream.readAllData()
                print("Got body:", String(data: data, encoding: .utf8) ?? "")
                
                do {
                    let removingEvent = try JSONDecoder().decode(EventAPI.Request.Remove.self, from: data)
                    
                    guard let index = events.firstIndex(where: {$0.id == removingEvent.id}) else {
                        return MockResponse(statusCode: 400, data: Data())
                    }
                    
                    events.remove(at: index)
                    return MockResponse(statusCode: 200, data: Data())
                    
                } catch {
                    print("Ошибка при декодировании: \(error)")
                    return MockResponse(statusCode: 400, data: Data())
                }
            }
            
            return MockResponse(statusCode: 400, data: Data())
        }
        
        registerMock(url: "https://api.app-osnova.ru/api/v1/events/update") { [weak self] request in
            guard let self else {
                return MockResponse(statusCode: 400, data: Data())
            }
            
            if let stream = request.httpBodyStream {
                let data = stream.readAllData()
                print("Got body:", String(data: data, encoding: .utf8) ?? "")
                
                do {
                    let updatingEvent = try JSONDecoder().decode(EventAPI.Request.Update.self, from: data)
                    
                    guard let index = events.firstIndex(where: {$0.id == updatingEvent.id}) else {
                        return MockResponse(statusCode: 400, data: Data())
                    }

                    events[index].maxParticipants = updatingEvent.maxParticipants
                    events[index].date = updatingEvent.date
                    events[index].address = updatingEvent.address
                    events[index].sportType = updatingEvent.sportType
                    
                    guard let ret = events[index].toJSON() else {
                        return MockResponse(statusCode: 400, data: Data())
                    }
                    
                    return MockResponse(statusCode: 200, data: Data(ret.utf8))
                    
                } catch {
                    print("Ошибка при декодировании: \(error)")
                    return MockResponse(statusCode: 400, data: Data())
                }
            }
            
            return MockResponse(statusCode: 400, data: Data())
        }
    }
}
