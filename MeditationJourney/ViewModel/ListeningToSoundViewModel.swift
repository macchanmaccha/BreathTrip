//
//  ListeningToSoundViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/01/06.
//

import SwiftUI

class ListeningToSoundViewModel: ObservableObject {
    // 瞑想中断アラートを管理する変数
    @Published var isShowStopAlert: Bool = false
    // 瞑想終了アラートを管理する変数
    @Published var isShowEndAlert: Bool = false
    // 中断ボタンの表示を管理する変数
    @Published var isShowStopButton: Bool = true
    // タイマー
    @Published var timerHandler: Timer?
    // 瞑想前カウントダウンの変数
    @Published var preparationCountDown = 5
    // 瞑想中タイマーの分数・秒数を管理する変数
    @Published var remainingSeconds: Int = 0
    // 瞑想前中断中タイマーを保存する変数 初期値は5
    @Published var interruptingPreparationTimer: Int = 5
    // 瞑想中断中タイマーを保存する変数
    @Published var interruptingMeditationTimer: Int = 0
    // 選択した分数
    @Published var selectedMinutes: Int
    // イニシャライザ
    init(selectedMinutes: Int) {
        self.selectedMinutes = selectedMinutes
    }
    // 瞑想中タイマー
    func startMeditationTimer() {
        remainingSeconds = interruptingMeditationTimer > 0 ? interruptingMeditationTimer : selectedMinutes * 60
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            print("瞑想中タイマー\(#fileID) \(#function) \(#line)")
            // 瞑想中断アラートがfalseなら
            if isShowStopAlert == false {
                // 1秒より大きいとき
                if remainingSeconds > 1 {
                    // マイナス1ずつしていく
                    remainingSeconds -= 1
                    // 1の場合（0秒となる前）
                } else if remainingSeconds == 1 {
                    // タイマーを停止
                    timerHandler?.invalidate()
                    // タイマーを無効に
                    timerHandler = nil
                    // 中断ボタン非表示
                    isShowStopButton = false
                    // 終了アラート表示
                    isShowEndAlert = true
                }
                // それ以外の場合（瞑想中断アラートがtrueの場合）
            } else {
                // タイマーを停止
                timerHandler?.invalidate()
                // タイマーを無効に
                timerHandler = nil
            }
        }
    } // startMeditationTimer
    // 分と秒の表示
    func formattedTime() -> String {
        // 60で割ったものを分数表示に
        let minutes = remainingSeconds / 60
        // あまりは秒数に
        let seconds = remainingSeconds % 60
        // 〇〇:〇〇表示でリターン
        return String(format: "%02d:%02d", minutes, seconds)
    }
} // classここまで
