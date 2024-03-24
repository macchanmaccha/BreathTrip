//
//  MeditatingSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/12/25.
//

import SwiftUI

class MeditatingSetViewModel: SetViewModel {
    // 瞑想画面での状態　初期値はend
    @Published private(set) var state: State = .end
    enum State {
        case preStart  // 瞑想前タイマーカウントダウン
        case prePause  // 瞑想前タイマー中断
        case start     // 瞑想タイマーカウントダウン
        case pause     // 瞑想タイマー中断
        case end       // 瞑想終了
    } // enumここまで
    // タイマーの初期値(瞑想前タイマー5秒)をセット
    func setFirstTimer() {
        remainingSeconds = 5
    }
    // 状態の更新
    func updateState(newState: State) {
        if state == .preStart && newState == .start {
            selectedMinutes = selectedMeditationMinutes
            // 瞑想タイマーをセット
            remainingSeconds = selectedMinutes * 60
        }
        state = newState
    }
    // 瞑想前タイマー
    func startPreparationTimer() {
        stopTimer()
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // preStartのとき
            if state == .preStart {
                // 1より大きいとき
                if remainingSeconds > 1 {
                    // 1ずつマイナス
                    remainingSeconds -= 1
                    // 1の場合（0秒となる前）
                } else if remainingSeconds == 1 {
                    updateState(newState: .start)
                    // タイマーが有効かチェック
                    print("\(#fileID) \(#function) \(#line) \(String(describing: self.timerHandler?.isValid))")
                } // else ifここまで
            } // if state == .preStartここまで
        } // timerHandlerここまで
    } // funcここまで
    // 瞑想中タイマー
    func startMeditationTimer() {
        // 多重でタイマーを開始しないようにタイマー停止をする
        stopTimer()
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            print("瞑想中タイマー\(#fileID) \(#function) \(#line)")
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
    // 音の設定
    override func setSelectedSoundName(soundName: SoundModel) {
        selectedMeditationSoundName = soundName.rawValue
    }
} // MeditatingViewModel
