//
//  MeditatingViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/12/25.
//

import SwiftUI

class MeditatingViewModel: ObservableObject {
    // タイマー
    private var timerHandler: Timer?
    // 瞑想画面での状態　初期値はend
    @Published var stateModel: MeditatingStateModel = .end
    // 瞑想前カウントダウンの変数
    @Published var preparationCountDown = 15
    // 瞑想中タイマーの分数・秒数を管理する変数
    @Published var remainingSeconds: Int = 0
    // 瞑想前中断中タイマーを保存する変数 初期値は5
    @Published var interruptingPreparationTimer: Int = 15
    // 瞑想中断中タイマーを保存する変数
    @Published var interruptingMeditationTimer: Int = 0
    // 選択した分数
    @Published var selectedMinutes: Int
    // イニシャライザ
    init(selectedMinutes: Int) {
        self.selectedMinutes = selectedMinutes
    }
    // 瞑想前タイマー
    func startPreparationTimer() {
        preparationCountDown = interruptingPreparationTimer
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // preStartのとき
            if stateModel == .preStart {
                // 1より大きいとき
                if preparationCountDown > 1 {
                    // 1ずつマイナス
                    preparationCountDown -= 1
                    // 1の場合（0秒となる前）
                } else if preparationCountDown == 1 {
                    // 状態をstartに
                    stateModel = .start
                    // タイマー停止・無効
                    stopTimer()
                    // 瞑想タイマー関数の呼び出し
                    startMeditationTimer()
                    // タイマーが有効かチェック
                    print("\(#fileID) \(#function) \(#line) \(String(describing: self.timerHandler?.isValid))")
                }
                // pauseのとき
            } else if stateModel == .prePause {
                // タイマー停止・無効
                stopTimer()
            }
        }
    }
    // 瞑想中タイマー
    func startMeditationTimer() {
        remainingSeconds = interruptingMeditationTimer > 0 ? interruptingMeditationTimer : selectedMinutes * 60
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            print("瞑想中タイマー\(#fileID) \(#function) \(#line)")
            // 瞑想中なら
            if stateModel == .start {
                // 1秒より大きいとき
                if remainingSeconds > 1 {
                    // マイナス1ずつしていく
                    remainingSeconds -= 1
                    // 1の場合（0秒となる前）
                } else if remainingSeconds == 1 {
                    // end
                    stateModel = .end
                    // タイマー停止・無効
                    stopTimer()
                }
                // pauseのとき
            } else if stateModel == .pause {
                // タイマー停止・無効
                stopTimer()
            }
        }
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
    }
} // MeditatingViewModel
