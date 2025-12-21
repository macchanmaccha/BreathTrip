//
//  ListeningSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import SwiftUI

class ListeningSetViewModel: SetViewModel {
    /// 音をきく画面での状態　初期値はend
    @Published private(set) var timerState: TimerState = .end
    /// 選択する時間を管理する変数
    @Published private(set) var selectedMinutes: Int = 1
    /// 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published private(set) var remainingSeconds: Int = 0
    /// タイマー
    private var timer: Timer?
    /// タイマーの終了時刻を管理する変数
    private var listeningEndTime: Date?
    /// 状態の更新
    func updateState(to: TimerState) {
        if timerState == .end && to == .start {
            // listeningMinutesが0でないとき
            if listeningMinutes != 0 {
                // 音再生タイマーをセット
                remainingSeconds = listeningMinutes * 60
                // listeningMinutesが0のとき
            } else {
                remainingSeconds = 0
            }
        }
        timerState = to
    }
    // 音をきくタイマー
    func startListeningTimer() {
        // 多重でタイマーを開始しないようにタイマー停止をする
        stopTimer()
        // remainingSecondsが0より大きいとき
        guard remainingSeconds > 0 else {
            return
        }
        // 終了時刻は、残り時間+1秒を考慮
        listeningEndTime = Date().addingTimeInterval(TimeInterval(remainingSeconds + 1))
        // タイマー起動
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // 瞑想中なら
            if timerState == .start {
                // endTimeが存在するとき
                if let endTime = self.listeningEndTime {
                    // 現在時刻と終了時刻の差を評価し、0以上の値を返す
                    let remainingTimeInterval = max(0, endTime.timeIntervalSince(Date()))
                    // Int型に変換してremainingSecondsに格納
                    remainingSeconds = Int(remainingTimeInterval)
                    // remainingSecondsが0以下のとき
                    if remainingSeconds <= 0 {
                        // end
                        timerState = .end
                        // タイマー停止
                        stopTimer()
                    } // if remainingSeconds <= 0
                }  // if let endTime
            }  // if state == .startここまで
        }  // timerHandlerここまで
    }  // startListeningTimer
    /// タイマー停止・無効
    func stopTimer() {
        // タイマー停止
        timer?.invalidate()
        // タイマー無効
        timer = nil
    }  // stopTimer
    /// 時間と音の保存
    override func saveSoundAndMinutes(soundName: SoundModel) {
        listeningSoundName = soundName
        saveListeningSound()
        saveListeningMinutes()
    }
    deinit {
        stopTimer()
    }
}  // ListeningSetViewModelここまで
extension ListeningSetViewModel {
    enum TimerState {
        case start  // 音再生タイマーカウントダウン
        case pause  // 音再生タイマー中断
        case end  // 音再生終了
    }  // enumここまで
}  // extension ListeningSetViewModelここまで
