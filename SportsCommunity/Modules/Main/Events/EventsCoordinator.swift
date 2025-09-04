//
//  EventCoordinator.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 12.08.2025.
//

import Foundation
import UIKit

final class EventsCoordinator: Coordinator {
    
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    let eventsService: EventsNetworkProtocol
    
    init (navigationController: UINavigationController, eventsService: EventsNetworkProtocol) {
        self.navigationController = navigationController
        self.eventsService = eventsService
    }
    
    func start() {
        let router = EventsListRouter()
        router.delegate = self
        let viewModel = EventsListViewModel(router: router, eventsService: self.eventsService)
        let viewController = EventsListViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
        
        viewController.navigationItem.title = MainRouteType.events.title
        viewController.navigationItem.largeTitleDisplayMode = .inline
    }
}

extension EventsCoordinator : EventsListRouterDelegate {
    func goToCreateEvent() {
        let router = EventEditorRouter()
        router.delegate = self
        let viewModel = EventEditorViewModel(router: router, eventsService: self.eventsService)
        let viewController = EventEditorViewController(viewModel: viewModel, mode: .create)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToEditEvent(_ event: Event.View) {
        let router = EventEditorRouter()
        router.delegate = self
        let viewModel = EventEditorViewModel(router: router, eventsService: self.eventsService)
        let viewController = EventEditorViewController(viewModel: viewModel, mode: .edit(event))
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension EventsCoordinator : EventEditorRouterDelegate {
    func didFinishCreateEvent(_ event: Event.View) {
        self.navigationController.viewControllers
            .compactMap { $0 as? EventsListViewController }
            .first?
            .notifyEventCreate(event)
        navigationController.popViewController(animated: true)
    }
    
    func didFinishEditEvent(_ event: Event.Edit) {
        self.navigationController.viewControllers
            .compactMap { $0 as? EventsListViewController }
            .first?
            .updateEvent(event)
        navigationController.popViewController(animated: true)
    }
    
    func didCancel() {
        navigationController.popViewController(animated: true)
    }
}
