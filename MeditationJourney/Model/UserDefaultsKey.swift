//
//  UserDefaultsKey.swift
//  MeditationJourney
//
//  Created by Yoshinori Kobayashi on 2024/04/03.
//

import Foundation

enum UserDefaultsKey {
    static let meditationSoundName = "meditationSoundName"
    static let meditationMinutes = "meditationMinutes"
    static let listeningMinutes = "listeningMinutes"

    static func register () {
        UserDefaults.standard.register(defaults: [
            // SoundModel.europe1で保存するとアプリが落ちるので、rawValueで保存
            UserDefaultsKey.meditationSoundName: SoundModel.europe1.rawValue,
            UserDefaultsKey.meditationMinutes: 1,
            UserDefaultsKey.listeningMinutes: 10
        ])
    }
}
