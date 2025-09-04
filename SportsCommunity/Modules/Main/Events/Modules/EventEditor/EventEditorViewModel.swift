//
//  EventEditorViewModel.swift
//  ApplicationName
//
//  Created by Илья Макаров on 12.08.2025
//

import Foundation

final class EventEditorViewModel {
    
    // MARK: - Property
    
    private let router: EventEditorRouter
    private let eventsService: EventsNetworkProtocol
    
    // MARK: - Closure
    
    var onNotify: ((_ message: String, _ completion: @escaping () -> Void) -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    // MARK: - Init
    
    init(router: EventEditorRouter, eventsService: EventsNetworkProtocol) {
        self.router = router
        self.eventsService = eventsService
    }
    
    // MARK: - Method
    
    func add(event: Event.Create) {
        self.onLoading?(true)

        let eventRequestAdd = event.toEventAPI()
        
        eventsService.addEvent(eventRequestAdd) { [weak self] result in
            guard let self = self else { return }
            
            self.onLoading?(false)
            
            switch (result) {
            case .success(let addedEvent):
                let eventView = Event.View(id: addedEvent.id,
                                           name: event.name,
                                           participants: 0,
                                           maxParticipants: event.maxParticipants,
                                           date: event.date,
                                           address: event.address,
                                           sportType: event.sportType)
                router.didFinishCreateEvent(eventView)
            case .failure(let error):
                print(error.localizedDescription)
                self.onError?(L10n.Message.Events.Create.failure)
            }
        }
    }
    
    func update(event: Event.Edit) {
        
        self.onLoading?(true)

        let eventRequestEdit = event.toEventAPI()
        
        eventsService.updateEvent(eventRequestEdit) { [weak self] result in
            guard let self = self else { return }
            
            self.onLoading?(false)
            
            switch (result) {
            case .success(let updatedEvent):
                do {
                    let editedEvent = try Event.Edit(from: updatedEvent)
                    router.didFinishEditEvent(editedEvent)
                }
                catch {
                    print(error.localizedDescription)
                    self.onError?(L10n.Message.Events.Edit.failure)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.onError?(L10n.Message.Events.Edit.failure)
            }
        }
    }
    
    func cancel() {
        router.didCancel()
    }
}
