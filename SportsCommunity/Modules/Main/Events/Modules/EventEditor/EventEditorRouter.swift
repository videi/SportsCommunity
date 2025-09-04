//
//  EventEditorRouter.swift
//  ApplicationName
//
//  Created by Илья Макаров on 12.08.2025
//

import Foundation

protocol EventEditorRouterDelegate: AnyObject {
    func didFinishCreateEvent(_ event: Event.View)
    func didFinishEditEvent(_ event: Event.Edit)
    func didCancel()
}

final class EventEditorRouter {
    weak var delegate: EventEditorRouterDelegate?
    
    func didFinishCreateEvent(_ event: Event.View){
        delegate?.didFinishCreateEvent(event)
    }
    
    func didFinishEditEvent(_ event: Event.Edit) {
        delegate?.didFinishEditEvent(event)
    }
    
    func didCancel() {
        delegate?.didCancel()
    }
}
