//
//  SoundSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import Foundation

class SetViewModel: ObservableObject {
    // 選択した音を表示する変数
    @Published var meditationSoundName: SoundModel {
        didSet {UserDefaults.standard.set(meditationSoundName.rawValue, forKey: UserDefaultsKey.meditationSoundName)}
    }
    @Published var listeningSoundName: SoundModel {
        didSet {UserDefaults.standard.set(listeningSoundName.rawValue, forKey: UserDefaultsKey.listeningSoundName)}
    }
    @Published var meditationMinutes: Int {
        didSet {UserDefaults.standard.set(meditationMinutes, forKey: UserDefaultsKey.meditationMinutes)}
    }
    @Published var listeningMinutes: Int {
        didSet {UserDefaults.standard.set(listeningMinutes, forKey: UserDefaultsKey.listeningMinutes)}
    }
    /// 選択する時間を管理する変数
    @Published var selectedMinutes: Int = 1
    /// 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published var remainingSeconds: Int = 0
    /// タイマー
    var timerHandler: Timer?
    // 初期化
    init() {
        meditationSoundName = SoundModel(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.meditationSoundName) ?? SoundModel.europe1.rawValue) ?? SoundModel.europe1
        listeningSoundName = SoundModel(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.listeningSoundName) ?? SoundModel.europe1.rawValue) ?? SoundModel.europe1
        meditationMinutes = UserDefaults.standard.integer(forKey: "selectedMeditationMinutes")
        listeningMinutes = UserDefaults.standard.integer(forKey: "selectedListeningMinutes")
    }
    /// 音の設定 MeditatingSetViewModelおよびListeningSetViewModelでoverride
    func setSelectedSoundName(soundName: SoundModel) {
    }
    /// タイマー停止・無効
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
    /// 設定値の再取得 MeditatingSetViewModelおよびListeningSetViewModelでoverride
    func setSoundModel() {
    }
} // SetViewModelここまで
