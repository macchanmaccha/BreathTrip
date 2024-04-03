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

    init() {
        // UserDefaultsはプロジェクト全体で使える
        // プロジェクト全体で使われるので、プロジェクトの最初のイニシャライズでregisterを登録
        UserDefaults.standard.register(defaults: [
            UserDefaultsKey.selectedMeditationSoundName: SoundModel.europe1,
            UserDefaultsKey.selectedListeningSoundName: SoundModel.europe1,
            UserDefaultsKey.selectedMeditationMinutes: 1,
            UserDefaultsKey.selectedListeningMinutes: 10,
        ])
    }
    var body: some Scene {
        WindowGroup {
            TabSetView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
