//
//  MeditationJourneyApp.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/10.
//

import SwiftUI

@main
struct MeditationJourneyApp: App {
    /// UserDefaultsのデフォルト値を設定
    init() {
        UserDefaultsKey.register()
    }
    var body: some Scene {
        WindowGroup {
            TabSetView()
        }
    }
}
