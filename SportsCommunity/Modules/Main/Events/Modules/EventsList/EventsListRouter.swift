//
//  EventsRouter.swift
//  ApplicationName
//
//  Created by Илья Макаров on 24.01.2025
//

import Foundation

protocol EventsListRouterDelegate: AnyObject {
    func goToCreateEvent()
    func goToEditEvent(_ event: Event.View)
}

final class EventsListRouter {
    weak var delegate: EventsListRouterDelegate?
    
    func goToCreateEvent() {
        delegate?.goToCreateEvent()
    }
    
    func goToEditEvent(_ event: Event.View) {
        delegate?.goToEditEvent(event)
    }
}
