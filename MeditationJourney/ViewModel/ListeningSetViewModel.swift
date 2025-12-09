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
    /// 選択する時間を管理する変数
    @Published private(set) var selectedMinutes: Int = 1
    /// 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published private(set) var remainingSeconds: Int = 0
    /// タイマー
    var timer: Timer?
    /// タイマーの終了時刻を管理する変数
    private var endTime: Date?
    /// 状態の更新
    func updateState(to: State) {
        if state == .end && to == .start {
            // listeningMinutesが0でないとき
            if listeningMinutes != 0 {
                selectedMinutes = listeningMinutes
                // 音再生タイマーをセット
                remainingSeconds = selectedMinutes * 60
                // listeningSecondsが0のとき
            } else {
                remainingSeconds = 0
            }
        }
        state = to
    }
    // 瞑想中タイマー
    func startListeningTimer() {
        // 多重でタイマーを開始しないようにタイマー停止をする
        stopTimer()
        // remainingSecondsが0より大きとき
        guard remainingSeconds > 0 else {
            return
        }
        // 終了時刻は、残り時間+1秒を考慮（60:00もカウントに含めるため）
        endTime = Date().addingTimeInterval(TimeInterval(remainingSeconds + 1))
        // タイマー起動
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // 瞑想中なら
            if state == .start {
                // endTimeが存在するとき
                if let endTime = self.endTime {
                    // 現在時刻と終了時刻の差を評価し、0以上の値を返す
                    let remainigTimeInterval = max(0, endTime.timeIntervalSince(Date()))
                    // Int型に変換してremainingSecondsに格納
                    remainingSeconds = Int(remainigTimeInterval)
                    // remainingSecondsが0以下のとき
                    if remainingSeconds <= 0 {
                        // end
                        state = .end
                        // タイマー停止
                        stopTimer()
                    } // if remainingSeconds <= 0
                }  // if let endTime
            }  // if state == .startここまで
        }  // timerHandlerここまで
    }  // startMeditationTimer
    /// タイマー停止・無効
    func stopTimer() {
        // タイマー停止
        timer?.invalidate()
        // タイマー無効
        timer = nil
    }  // stopTimer
    /// 音の設定
    override func setSelectedSoundName(soundName: SoundModel) {
        listeningSoundName = soundName
        saveListeningSound()
        saveListeningMinutes()
    }
}  // ListeningSetViewModelここまで
extension ListeningSetViewModel {
    enum State {
        case start  // 音再生タイマーカウントダウン
        case pause  // 音再生タイマー中断
        case end  // 音再生終了
    }  // enumここまで
}  // extension ListeningSetViewModelここまで
