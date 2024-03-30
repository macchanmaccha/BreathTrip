//
//  SoundSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import Foundation

class SetViewModel: ObservableObject {
    // UserDefaultsのキー
    enum UserDefaultsKey {
        static let selectedMeditationSoundName = "selectedMeditationSoundName"
        static let selectedListeningSoundName = "selectedMeditationSoundName"
        static let selectedMeditationMinutes = "selectedMeditationMinutes"
        static let selectedListeningMinutes = "selectedListeningMinutes"
    }
    // 選択した音を表示する変数
    @Published var selectedMeditationSoundName: String {
        didSet {UserDefaults.standard.set(selectedMeditationSoundName, forKey: UserDefaultsKey.selectedMeditationSoundName)}
    }
    @Published var selectedListeningSoundName: String {
        didSet {UserDefaults.standard.set(selectedListeningSoundName, forKey: UserDefaultsKey.selectedListeningSoundName)}
    }
    @Published var selectedMeditationMinutes: Int {
        didSet {UserDefaults.standard.set(selectedMeditationMinutes, forKey: UserDefaultsKey.selectedMeditationMinutes)}
    }
    @Published var selectedListeningMinutes: Int {
        didSet {UserDefaults.standard.set(selectedListeningMinutes, forKey: UserDefaultsKey.selectedListeningMinutes)}
    }
    // 初期化
    init() {
        selectedMeditationSoundName = UserDefaults.standard.string(forKey: "selectedMeditationSoundName") ?? SoundModel.europe1.rawValue
        selectedListeningSoundName = UserDefaults.standard.string(forKey: "selectedListeningSoundName") ?? SoundModel.europe1.rawValue
        selectedMeditationMinutes = 1
        selectedMeditationMinutes = UserDefaults.standard.integer(forKey: "selectedMeditationMinutes")
        selectedListeningMinutes = 10
        selectedListeningMinutes = UserDefaults.standard.integer(forKey: "selectedListeningMinutes")
    }
    // 選択する時間を管理する変数
    @Published var selectedMinutes: Int = 1
    // 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published var remainingSeconds: Int = 0
    // タイマー
    var timerHandler: Timer?
    // 音の設定 MeditatingSetViewModelおよびListeningSetViewModelでoverride
    func setSelectedSoundName(soundName: SoundModel) {
    }
    // タイマー停止・無効
    func stopTimer() {
        // タイマー停止
        timerHandler?.invalidate()
        // タイマー無効
        timerHandler = nil
    }
    // 分と秒の表示
    func formattedTime() -> String {
        // 60で割ったものを分数表示に
        let minutes = remainingSeconds / 60
        // あまりは秒数に
        let seconds = remainingSeconds % 60
        // 〇〇:〇〇表示でリターン
        return String(format: "%02d:%02d", minutes, seconds)
    } // func formattedTime()ここまで
} // SoundSetViewModelここまで
