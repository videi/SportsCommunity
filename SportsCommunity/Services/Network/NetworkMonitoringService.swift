//
//  NetworkMonitoringService.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 06.03.2025.
//

import Foundation
import Alamofire

public protocol NetworkMonitoringProtocol {
    
    var isStart: Bool { get }
    var isConnected: Bool { get }
    var checkURL: URL { get set }
    
    var delegate: NetworkMonitorDelegate? { get set }
    
    func startMonitoring()
    func stopMonitoring()
    func checkConnection(completion: @escaping (Bool) -> Void)
}

public protocol NetworkMonitorDelegate: AnyObject {
    func networkStatusDidChange(isConnected: Bool)
}

final class NetworkMonitoringService : NetworkMonitoringProtocol {
    
    private let reachbilityManager = NetworkReachabilityManager()
    private(set) var isConnected: Bool = false
    private(set) var isStart: Bool = false
 
    weak var delegate: (any NetworkMonitorDelegate)?
    var checkURL: URL = URL(string: "https://www.google.com")!
    
    func startMonitoring() {
        reachbilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            
            guard let self = self else { return }
            
            let prevConnectionStatus = self.isConnected
            
            switch status {
            case .notReachable, .unknown:
                self.isConnected = false
            case .reachable:
                self.isConnected = true
            }
            
            if prevConnectionStatus != self.isConnected {
                delegate?.networkStatusDidChange(isConnected: self.isConnected)
            }
        })
        
        isStart = true
    }
    
    func stopMonitoring() {
        reachbilityManager?.stopListening()
        isStart = true
    }
    
    func checkConnection(completion: @escaping (Bool) -> Void) {
        if let isReachable = reachbilityManager?.isReachable {
            completion(isReachable)
        } else {
            // Активная проверка через HTTP запрос
            AF.request(checkURL).validate().response { [weak self] response in
                
                let isConnected = response.error == nil
                
                if let self = self, self.isConnected != isConnected {
                    self.isConnected = isConnected
                    self.delegate?.networkStatusDidChange(isConnected: isConnected)
                }
                
                completion(isConnected)
            }
        }
    }
}
