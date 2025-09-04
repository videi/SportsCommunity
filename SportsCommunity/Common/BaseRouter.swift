//
//  Route.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 17.01.2025.
//

import Foundation
import UIKit

protocol RouterProtocol : AnyObject {
    
    var navigationController: UINavigationController { get }
    
    func push(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
}

class BaseRouter {
    
    weak var sourceViewController: UIViewController?
    
    init(sourceViewController: UIViewController) {
        self.sourceViewController = sourceViewController
    }
}
