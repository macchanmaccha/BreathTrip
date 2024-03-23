//
//  SoundSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import SwiftUI

class SetViewModel: ObservableObject {
    // 選択した音を表示する変数
    //    @AppStorage("selected_Sound") var selectedSoundName: SoundModel = .europe1
    @Published var selectedMeditationSoundName: SoundModel {
        didSet {UserDefaults.standard.set(selectedMeditationSoundName, forKey: "selectedMeditationSoundName")}
    }
    @Published var selectedListeningSoundName: SoundModel {
        didSet {UserDefaults.standard.set(selectedListeningSoundName, forKey: "selectedListeningSoundName")}
    }
    @Published var selectedMeditationMinutes: Int {
        didSet {UserDefaults.standard.set(selectedMeditationMinutes, forKey: "selectedMeditationMinutes")}
    }
    @Published var selectedListeningMinutes: Int {
        didSet {UserDefaults.standard.set(selectedListeningMinutes, forKey: "selectedListeningMinutes")}
    }
    // 初期化
    init() {
        selectedMeditationSoundName = SoundModel(rawValue: UserDefaults.standard.string(forKey: "selectedMeditationSoundName") ?? "") ?? .europe1
        selectedListeningSoundName = SoundModel(rawValue: UserDefaults.standard.string(forKey: "selectedListeningSoundName") ?? "") ?? .europe1
        selectedMeditationMinutes = UserDefaults.standard.integer(forKey: "selectedMeditationMinutes")
        selectedListeningMinutes = UserDefaults.standard.integer(forKey: "selectedListeningMinutes")
    }
    // 選択する時間を管理する変数
    @Published var selectedMinutes: Int = 10
    // 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published var remainingSeconds: Int = 0
    // タイマー
    var timerHandler: Timer?
    // 音の設定
    func setSelectedSoundName(soundName: SoundModel) {
    }
} // SoundSetViewModelここまで
