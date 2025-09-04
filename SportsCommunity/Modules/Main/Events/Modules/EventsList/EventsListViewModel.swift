//
//  EventsViewModel.swift
//  ApplicationName
//
//  Created by Илья Макаров on 24.01.2025
//

import Foundation

final class EventsListViewModel {
    
    // MARK: - Property
    
    private let router: EventsListRouter
    private let eventsService: EventsNetworkProtocol
    
    var events: [Event.View] = []
    var selectedDate: Date
    
    //MARK: - Closure
    
    var onNotify: ((_ message: String, _ completion: @escaping () -> Void) -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onLoaded: (([Event.View]) -> Void)?
    var onDeleted: (() -> Void)?
    
    // MARK: - Init
    
    init(router: EventsListRouter, eventsService: EventsNetworkProtocol) {
        self.router = router
        self.eventsService = eventsService
        self.selectedDate = .now
    }
    
    deinit {
        print("\(String(describing: type(of: self))) deinitialized")
    }
    
    // MARK: - Method
    
    func loadEvents() {
        self.onLoading?(true)
        
        eventsService.getEvents { [weak self] result in
            guard let self = self else { return }
            
            self.onLoading?(false)
            
            switch (result) {
            case .success(let eventsApi):
                do {
                    let mapEvents = try eventsApi.map{ try Event.View(from: $0) }
                    events.append(contentsOf: mapEvents)
                    self.onLoaded?(events)
                }
                catch {
                    print(error.localizedDescription)
                    self.onError?(L10n.Message.Events.Load.failure)
                }
                break
            case .failure(let error):
                print("\(error.localizedDescription)")
                self.onError?(L10n.Message.Events.Load.failure)
            }
        }
    }
    
    func updateEvent(_ event: Event.Edit) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else {
            print("event \(event.id) not found")
            return
        }
        
        events[index].maxParticipants = event.maxParticipants
        events[index].address = event.address
        events[index].date = event.date
        events[index].sportType = event.sportType
    }
    
    func createEvent() {
        self.router.goToCreateEvent()
    }
    
    func editEvent(_ event: Event.View) {
        self.router.goToEditEvent(event)
    }
    
    func removeEvent(id: Int, completion: @escaping () -> Void) {
        
        self.onLoading?(true)
        
        eventsService.removeEvent(EventAPI.Request.Remove(id: id)) { [weak self] result in
            guard let self = self else { return }

            self.onLoading?(false)
            
            switch (result) {
            case .success():
                guard let index = events.firstIndex(where: { $0.id == id }) else {
                    print("id in events not found")
                    self.onError?(L10n.Message.Events.Delete.failure)
                    return
                }
                events.remove(at: index)
                completion()
            case .failure(let error):
                print("\(error.localizedDescription)")
                self.onError?(L10n.Message.Events.Delete.failure)
            }
        }
    }
}
