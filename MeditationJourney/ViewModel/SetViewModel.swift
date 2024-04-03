//
//  SoundSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import Foundation

class SetViewModel: ObservableObject {
    // 選択した音を表示する変数
    @Published var soundModel: SoundModel {
        // 列挙型SoundModelのままではアプリが落ちるので、文字列で保存
        didSet {UserDefaults.standard.set(soundModel.rawValue, forKey: UserDefaultsKey.meditationSoundName)}
    }
    @Published var meditationMinutes: Int {
        didSet {UserDefaults.standard.set(meditationMinutes, forKey: UserDefaultsKey.meditationMinutes)}
    }
    @Published var listeningMinutes: Int {
        didSet {UserDefaults.standard.set(listeningMinutes, forKey: UserDefaultsKey.listeningMinutes)}
    }

    // 選択する時間を管理する変数
    @Published var selectedMinutes: Int = 1
    // 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published var remainingSeconds: Int = 0
    // タイマー
    var timerHandler: Timer?

    init() {
        // 列挙型SoundModelが文字列で保管されているので、列挙値に変換する
        self.soundModel = SoundModel(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.meditationSoundName) ?? SoundModel.europe1.rawValue) ?? SoundModel.europe1
        self.meditationMinutes = UserDefaults.standard.integer(forKey: UserDefaultsKey.meditationMinutes)
        self.listeningMinutes = UserDefaults.standard.integer(forKey: UserDefaultsKey.listeningMinutes)
    }

    // 音の設定
    func setSelectedSoundName(soundName: SoundModel) {
        soundModel = soundName
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

    // UserDefaultsと同期するために、設定値を再取得
    func setSoundModel() {
        self.soundModel = SoundModel(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.meditationSoundName) ?? SoundModel.europe1.rawValue) ?? SoundModel.europe1
    }
} // SoundSetViewModelここまで
