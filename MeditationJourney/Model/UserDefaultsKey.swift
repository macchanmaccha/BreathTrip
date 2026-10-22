//
//  UserDefaultsKey.swift
//  MeditationJourney
//
//  Created by apple on 2024/04/07.
//

import Foundation

/// UserDefaultsのキーを一元管理
enum UserDefaultsKey {
    static let meditationSoundName = "meditationSoundName"
    static let listeningSoundName = "listeningSoundName"
    static let meditationMinutes = "meditationMinutes"
    static let listeningMinutes = "listeningMinutes"
    static let meditationRecords = "meditationRecords"
    /// 瞑想の音声ガイドON/OFF（MeditationSetViewのAppStorageと一致）
    static let audioGuide = "audioGuide"
    static func register() {
        UserDefaults.standard.register(defaults: [
            // SoundModel.europa1で保存するとアプリが落ちるので、rawValueで保存
            UserDefaultsKey.meditationSoundName: SoundModel.europa1.rawValue,
            UserDefaultsKey.listeningSoundName: SoundModel.europa1.rawValue,
            UserDefaultsKey.meditationMinutes: 1,
            UserDefaultsKey.listeningMinutes: 10
        ])
    }
}
