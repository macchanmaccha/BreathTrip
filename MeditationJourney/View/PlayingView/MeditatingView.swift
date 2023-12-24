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
    // 瞑想前中断中タイマーを保存する変数
    @State private var interruptingPreparationTimer: Int = 5
    // 瞑想中断中タイマーを保存する変数
    @State private var interruptingMeditationTimer: Int = 0
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
                    // 0秒が表示される前に1秒になったら
                } else if preparationCountDown == 1 {
                    // その後は表示しない（要は0秒を表示しない）
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
                        // 開始前残り秒数を格納する
                        interruptingPreparationTimer = preparationCountDown
                        // 瞑想中残り秒数を格納する
                        interruptingMeditationTimer = remainingSeconds
                        startPreparationTimer()
                        restartMeditationTimer()
                        // ノーを押したらisShowStopAlertをfalseにする
                        isShowStopAlert = false
                    }
                    Button("YES") {
                        timerHandler?.invalidate()
                        // タイマーを無効に
                        timerHandler = nil
                        // 中断アラートをfalse
                        isShowStopAlert = false
                        // 前の画面へ
                        dismiss()
                    }
                } message: {
                    Text("中断して前の画面に戻りますか？")
                } // .alertここまで
            } // VStackここまで
            // 戻るボタンは削除
            .navigationBarBackButtonHidden(true)
            .onAppear {
                isPreparationTimerRunning = true
                meditationCountDown = selectedMinutes
                startPreparationTimer()
            }
        } // ZStack
    } // bodyここまで
    // 瞑想前タイマー
    func startPreparationTimer() {
        preparationCountDown = interruptingPreparationTimer
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            // 瞑想中断アラートがfalseなら
            if isShowStopAlert == false && isPreparationTimerRunning {
                // 1より大きいとき
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
                    print("\(#fileID) \(#function) \(#line) \(timerHandler?.isValid)")
                }
            } else if isMeditatingTimerRunning {
                // 何もしない
            } else {
                // タイマーを停止
                timerHandler?.invalidate()
                // タイマーを無効に
                timerHandler = nil
            }
        }
    }
    // 瞑想中タイマー
    func startMeditationTimer() {
        // 分数を秒数に
//        remainingSeconds = selectedMinutes * 60
        remainingSeconds = 10
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            print("瞑想中タイマー\(#fileID) \(#function) \(#line)")
            // 瞑想中断アラートがfalseなら
            if isShowStopAlert == false && isMeditatingTimerRunning {
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
    func restartMeditationTimer() {
        // 中断時間をremainingSecondsに格納
        remainingSeconds = interruptingMeditationTimer
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            // 中断アラートがfalseなら
            if isShowStopAlert == false && isMeditatingTimerRunning {
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
