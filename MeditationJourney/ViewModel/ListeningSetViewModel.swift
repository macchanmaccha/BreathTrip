//
//  SoundSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import SwiftUI

class ListeningSetViewModel: SetViewModel {
    /// 音をきく画面での状態　初期値はend
    @Published private(set) var state: State = .end
    enum State {
        case start     // 音再生タイマーカウントダウン
        case pause     // 音再生タイマー中断
        case end       // 音再生終了
    } // enumここまで
    /// 音再生の分数
    @Published var listeningMinutes: Int {
        didSet {UserDefaults.standard.set(listeningMinutes, forKey: UserDefaultsKey.listeningMinutes)}
    }
    override init() {
        listeningMinutes = UserDefaults.standard.integer(forKey: UserDefaultsKey.listeningMinutes)
    }
    /// 選択する時間を管理する変数
    @Published var selectedMinutes: Int = 1
    /// 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published var remainingSeconds: Int = 0
    /// タイマー
    var timerHandler: Timer?
    /// 状態の更新
    func updateState(newState: State) {
        if state == .end && newState == .start {
            selectedMinutes = listeningMinutes
            // 音再生タイマーをセット
            remainingSeconds = selectedMinutes * 60
            print("入力した分数は\(remainingSeconds)だよ")
        }
        state = newState
    }
    // 瞑想中タイマー
    func startListenintTimer() {
        // 多重でタイマーを開始しないようにタイマー停止をする
        //        stopTimer()
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            print("音再生中タイマー\(#fileID) \(#function) \(#line)")
            // 瞑想中なら
            if state == .start {
                // 1秒より大きいとき
                if remainingSeconds > 1 {
                    // マイナス1ずつしていく
                    remainingSeconds -= 1
                    // 1の場合（0秒となる前）
                } else if remainingSeconds == 1 {
                    // end
                    state = .end
                } // else ifここまで
            } // if state == .startここまで
        } // timerHandlerここまで
    } // startMeditationTimer
    /// タイマー停止・無効
    func stopTimer() {
        // タイマー停止
        timerHandler?.invalidate()
        // タイマー無効
        timerHandler = nil
    } // stopTimer
        /// 分と秒の表示
        func formattedTime() -> String {
            // 60で割ったものを分数表示に
            let minutes = remainingSeconds / 60
            // あまりは秒数に
            let seconds = remainingSeconds % 60
            // 〇〇:〇〇表示でリターン
            return String(format: "%02d:%02d", minutes, seconds)
        } // func formattedTime()ここまで
    /// 音の設定
    override func setSelectedSoundName(soundName: SoundModel) {
        listeningSoundName = soundName
    }
    /// UserDefaultsと同期するために、設定値を再取得
    override func setSoundModel() {
        listeningSoundName = SoundModel(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.listeningSoundName) ?? SoundModel.europe1.rawValue) ?? SoundModel.europe1
    }
} // SoundSetViewModelここまで
