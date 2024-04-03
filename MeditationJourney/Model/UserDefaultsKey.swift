//
//  UserDefaultsKey.swift
//  MeditationJourney
//
//  Created by Yoshinori Kobayashi on 2024/04/03.
//

import Foundation

// UserDefaultsはプロジェクト全体で使われる
// Modelに切り出して、宣言する
enum UserDefaultsKey {
    static let selectedMeditationSoundName = "selectedMeditationSoundName"
    static let selectedListeningSoundName = "selectedMeditationSoundName"
    static let selectedMeditationMinutes = "selectedMeditationMinutes"
    static let selectedListeningMinutes = "selectedListeningMinutes"
}
