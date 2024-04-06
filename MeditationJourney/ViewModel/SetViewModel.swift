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
        static let meditationSoundName = "meditationSoundName"
        static let listeningSoundName = "listeningSoundName"
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
    // 選択した音を表示する変数
    @Published var meditationSoundName: String {
        didSet {UserDefaults.standard.set(meditationSoundName, forKey: UserDefaultsKey.meditationSoundName)}
    }
    @Published var listeningSoundName: String {
        didSet {UserDefaults.standard.set(listeningSoundName, forKey: UserDefaultsKey.listeningSoundName)}
    }
    @Published var meditationMinutes: Int {
        didSet {UserDefaults.standard.set(meditationMinutes, forKey: UserDefaultsKey.meditationMinutes)}
    }
    @Published var listeningMinutes: Int {
        didSet {UserDefaults.standard.set(listeningMinutes, forKey: UserDefaultsKey.listeningMinutes)}
    }
    // 初期化
    init() {
        meditationSoundName = UserDefaults.standard.string(forKey: "selectedMeditationSoundName") ?? SoundModel.europe1.rawValue
        listeningSoundName = UserDefaults.standard.string(forKey: "selectedListeningSoundName") ?? SoundModel.europe1.rawValue
        meditationMinutes = 1
        meditationMinutes = UserDefaults.standard.integer(forKey: "selectedMeditationMinutes")
        listeningMinutes = 10
        listeningMinutes = UserDefaults.standard.integer(forKey: "selectedListeningMinutes")
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
