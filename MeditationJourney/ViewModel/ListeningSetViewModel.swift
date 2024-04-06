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
    /// 音再生の状態
    enum State {
        case start     // 音再生タイマーカウントダウン
        case pause     // 音再生タイマー中断
        case end       // 音再生終了
    } // enumここまで
    /// 状態の更新
    func updateState(newState: State) {
        // もしスタート状態なら
        if state == .start {
            //
            selectedMinutes = selectedListeningMinutes
            // 音再生タイマーをセット
            remainingSeconds = selectedMinutes * 60
        }
        state = newState
    }
    /// 音の設定
    override func setSelectedSoundName(soundName: SoundModel) {
        selectedListeningSoundName = soundName.rawValue
    }
    /// 音再生中タイマー
        func startListeningTimer() {
            // 多重でタイマーを開始しないようにタイマー停止をする
            stopTimer()
            timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else {
                    return
                }
                print("瞑想中タイマー\(#fileID) \(#function) \(#line)")
                // 音再生中なら
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
        } // startListeningTimer
} // SoundSetViewModelここまで
