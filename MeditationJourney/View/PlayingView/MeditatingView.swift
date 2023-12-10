//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import SwiftUI

struct MeditatingView: View {
    // 開始前タイマー初期値5、4、3、2、1、スタート
    @State private var preparationCountDown = 5
    // 選択する時間を管理する変数
    var selectedMinutes: Int
    // 瞑想時間のカウントダウンの数を管理する変数
    @State var meditationCountDown: Int = 1
    // 分数・秒数を管理する変数
    @State private var remainingSeconds: Int = 0
    // タイマー
    @State private var timerHandler: Timer?
    // タイマーの表示を管理する変数
    @State private var isTimerRunning: Bool = false
    // カウントの変数
    @State var count: Int = 0
    // 永続化する秒数設定
    @AppStorage("timer_Value") var timerValue = 10
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) var dismiss
    @State private var isShowAlert: Bool = false
    var body: some View {
        VStack {
            Text(formattedTime())
            Text("\(preparationCountDown)")
                .font(.headline)
            Text("")
            Button(action: {
                isShowAlert.toggle()
            }) {
                Text("中断する")
                    .tint(.backgroundNavy)
                    .font(.title)
            }
            .padding()
            .background(Color.keyWhite)
            .frame(width: 150, height: 100)
            .alert("", isPresented: $isShowAlert) {
                Button("NO") {
                }
                Button("YES") {
                    // 前の画面へ
                    dismiss()
                }
            } message: {
                Text("中断して前の画面に戻りますか？")
            } // .alertここまで
        } // VStackここまで
        .navigationBarBackButtonHidden(true)
        .onAppear {
            meditationCountDown = selectedMinutes
            // タイマーの設定
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                // 0より大きいとき
                if preparationCountDown > 0 {
                    // 1ずつマイナス
                    preparationCountDown -= 1
                } else {
                    // タイマー停止
                    timer.invalidate()
                    startTimer2()
                }
            }
        }
    } // bodyここまで
    // カウントダウンする関数
    func countDownTimer() {
        // 経過時間にプラス1する
        count += 1
        // 残り時間が0以下のとき、タイマーを止める
        if timerValue - count <= 0 {
            // タイマー停止
            timerHandler?.invalidate()
        }
    } // func countDownTimer
    // カウントダウン開始の関数
    func startTimer() {
        // timerHandlerをアンラップしてunwraoedTimerHandlerに代入
        if let unwrapedTimerHandler = timerHandler {
            // もしタイマーが、実行中だったらスタートしない
            if unwrapedTimerHandler.isValid == true {
                // 何も処理しない
                return
            }
        }
        // 残り時間が0以下のとrき、count(経過時間)を0に初期化する
        if timerValue - count <= 0 {
            // count時間を0に初期化
            count = 0
        } // if timerValue - count
        // タイマーをスタート
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            // タイマー実行時に呼び出される
            // 1秒ごとに実行されてカウントダウンする関数を実行する
            countDownTimer()
        }
    } // startTimer
    func startTimer2() {
            remainingSeconds = selectedMinutes * 60
            timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else {
                    // タイマーを停止
                    timerHandler?.invalidate()
                    // タイマーを無効に
                    timerHandler = nil
                }
            }
        }

        func formattedTime() -> String {
            let minutes = remainingSeconds / 60
            let seconds = remainingSeconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
} // ContentViewここまで

struct MeditatingView_Previews: PreviewProvider {
    static var previews: some View {
        MeditatingView(selectedMinutes: 1)
    }
}
