//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import SwiftUI

struct MeditatingView: View {
    // 瞑想前タイマー初期値5、4、3、2、1、スタート
    @State private var preparationCountDown = 5
    // 選択する時間を管理する変数
    var selectedMinutes: Int
    // 瞑想中タイマーのカウントダウンの数を管理する変数
    @State var meditationCountDown: Int = 1
    // 瞑想中タイマーの分数・秒数を管理する変数
    @State private var remainingSeconds: Int = 0
    // タイマー
    @State private var timerHandler: Timer?
    // 瞑想前タイマーの表示を管理する変数
    @State private var isPreparationTimerRunning: Bool = false
    // 瞑想中タイマーの表示を管理する変数
    @State private var isMeditatingTimerRunning: Bool = false
    // カウントの変数
    @State var count: Int = 0
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) var dismiss
    // 瞑想中断アラートを管理する変数
    @State private var isShowStopAlert: Bool = false
    // 瞑想終了アラートを管理する変数
    @State private var isShowEndAlert: Bool = false
    // 中断中タイマーを保存する変数
    @State private var interruptingTimer: Int = 0
    var body: some View {
        ZStack {
            Image("IMG_0571")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                // 瞑想前タイマーが2秒以上もしくはisPreparationTimerRunningがtrueなら
                if preparationCountDown > 1 || isPreparationTimerRunning {
                    // 以下テキストを表示
                    Text("開始まで\n\(preparationCountDown)")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    // その他の条件なら
                } else if preparationCountDown == 1 {
                    // 何も表示しない
                }
                // isMeditatingTimerRunningがtrueなら瞑想中タイマーを表示
                if isMeditatingTimerRunning {
                    Text(formattedTime())
                        .font(.title)
                } else {
                    // 何も表示しない
                }
                // 中断ボタン
                Button(action: {
                    // 押下するとisShowAlertをtrueにし、アラートを表示
                    isShowStopAlert = true
                }) {
                    Text("中断する")
                        .tint(.backgroundNavy)
                        .font(.title)
                }
                .padding()
                .cornerRadius(8)
                .background(Color.keyWhite)
                .frame(width: 150, height: 100)
                .alert("", isPresented: $isShowStopAlert) {
                    Button("NO") {
                        // 残り秒数を格納する
                        interruptingTimer = remainingSeconds
                        // ノーを押したらisShowStopAlertをfalseにする
                        isShowStopAlert = false
                        restartTimer()
                    }
                    Button("YES") {
                        // タイマーを無効に
                        timerHandler = nil
                        // 前の画面へ
                        dismiss()
                    }
                } message: {
                    Text("中断して前の画面に戻りますか？")
                } // .alertここまで
                
            } // VStackここまで
            // 戻るボタンは削除
            .navigationBarBackButtonHidden(true)
            .alert("", isPresented: $isShowEndAlert) {
                Button("NO") {
                }
                Button("YES") {
                    // 前の画面へ
                }
            } message: {
                Text("中断して前の画面に戻りますか？")
            } // .alertここまで
            .onAppear {
                meditationCountDown = selectedMinutes
                startPrepationTimer()
            }
        } // ZStack
    } // bodyここまで
    // 瞑想前タイマー
    func startPrepationTimer() {
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            // 0より大きいとき
            if preparationCountDown > 1 {
                // 1ずつマイナス
                preparationCountDown -= 1
                isPreparationTimerRunning = true
            } else if preparationCountDown == 1 {
                // タイマー停止
                timerHandler?.invalidate()
                // タイマーを無効に
                timerHandler = nil
                // 瞑想前タイマー非表示
                isPreparationTimerRunning = false
                // 瞑想中タイマー表示
                isMeditatingTimerRunning = true
                // 瞑想タイマー関数の呼び出し
                startMeditationTimer()
            }
        }
    }
    // 瞑想中タイマー
    func startMeditationTimer() {
        // 分数を秒数に
        remainingSeconds = selectedMinutes * 60
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            // 瞑想中断アラートがfalseなら
            if isShowStopAlert == false {
                // 秒数が正の数なら
                if remainingSeconds > 0 {
                    // マイナス1ずつしていく
                    remainingSeconds -= 1
                    // 1の場合は
                } else if remainingSeconds == 1 {
                    // タイマーを停止
                    timerHandler?.invalidate()
                    // タイマーを無効に
                    timerHandler = nil
                    // 瞑想中タイマーを非表示
                    isMeditatingTimerRunning = false
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
    // 中断後カウントダウンをリスタートする関数
    func restartTimer() {
        // 中断時間をremainingSecondsに格納
        remainingSeconds = interruptingTimer
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            // 中断アラートがfalseなら
            if isShowStopAlert == false {
                // remainingSecondsが正数なら
                if remainingSeconds > 0 {
                    // マイナス1
                    remainingSeconds -= 1
                } else {
                }
            } else {
                // タイマーを停止
                timerHandler?.invalidate()
                // タイマーを無効に
                timerHandler = nil
            }
        }
    } // restartTimer
    // 分と秒の表示
    func formattedTime() -> String {
        // 60で割ったものを分数表示に
        let minutes = remainingSeconds / 60
        // あまりは秒数に
        let seconds = remainingSeconds % 60
        // 〇〇:〇〇表示でリターン
        return String(format: "%02d:%02d", minutes, seconds)
    }
} // ContentViewここまで

struct MeditatingView_Previews: PreviewProvider {
    static var previews: some View {
        MeditatingView(selectedMinutes: 1)
    }
}
