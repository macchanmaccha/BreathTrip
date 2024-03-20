//
//  UserDefaultsExtension.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/20.
//

import Foundation
extension UserDefaults {
    static let selectedMeditationSoundNameKey = "selectedMeditationSoundName"
    static let selectedListeningSoundNameKey = "selectedListeningSoundName"
    static let selectedMeditationMinutesKey = "selectedMeditationMinutes"
    static let selectedListeningMintesKey = "selectedListeningMintes"
    @objc dynamic var meditationSoundName: String {
        get { return UserDefaults.selectedMeditationSoundNameKey }
        set { set(newValue, forKey: UserDefaults.selectedMeditationSoundNameKey) }
    }
    @objc dynamic var listeningSoundName: String {
        get { return UserDefaults.selectedListeningSoundNameKey }
        set { set(newValue, forKey: UserDefaults.selectedListeningSoundNameKey) }
    }
    @objc dynamic var meditationMinutes: String {
        get { return UserDefaults.selectedMeditationMinutesKey }
        set { set(newValue, forKey: UserDefaults.selectedMeditationMinutesKey) }
    }
    @objc dynamic var listeningMinutes: String {
        get { return UserDefaults.selectedListeningMintesKey }
        set { set(newValue, forKey: UserDefaults.selectedListeningMintesKey) }
    }
}
