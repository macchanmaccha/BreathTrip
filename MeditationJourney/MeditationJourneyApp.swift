//
//  MeditationJourneyApp.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/10.
//

import SwiftUI

@main
struct MeditationJourneyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabSetView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
