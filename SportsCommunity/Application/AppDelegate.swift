//
//  AppDelegate.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 27.09.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    private var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        appCoordinator = AppCoordinator(window: window, navigationController: navigationController)
        
        self.window = window
        
        appCoordinator?.start()
        
        return true
    }
}

