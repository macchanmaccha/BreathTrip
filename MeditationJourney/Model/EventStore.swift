////
////  EventStore.swift
////  MeditationJourney
////
////  Created by apple on 2024/04/25.
////
//
//import Foundation
//
//@MainActor
//class EventStore: ObservableObject {
//    @Published var events = [Event]()
//    @Published var preview: Bool
//    init(preview: Bool) {
//        self.preview = preview
//        fetchEvents()
//    }
//    func fetchEvents() {
//        if preview {
//            events = Event.sampleEvents
//        } else {
//
//        }
//    }
//    func delete(_ event: Event) {
//        if let index = events.firstIndex(where: { $0.id == event.id }) {
//            events[index].date = event.date
//            events[index].note = event.note
//            events[index].eventType = event.eventType
//        }
//    }
//} // structEventStore
