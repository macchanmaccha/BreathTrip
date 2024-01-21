//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import SwiftUI

struct MeditatingView: View {
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) private var dismiss
    // viewModel
    @StateObject var viewModel: MeditatingViewModel
    // 瞑想前タイマーの表示を管理する変数
    @State private var isPreparationTimerRunning: Bool = false
    // 瞑想中タイマーの表示を管理する変数
    @State private var isMeditatingTimerRunning: Bool = false
    // 瞑想中断アラートを管理する変数
    @State private var isShowStopAlert: Bool = false
    // 瞑想終了アラートを管理する変数
    @State private var isShowEndAlert: Bool = false
    // 中断ボタンの表示を管理する変数
    @State private var isShowStopButton: Bool = true
    var body: some View {
        ZStack {
            Image(.playBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                // 瞑想前タイマーが2秒以上もしくはisPreparationTimerRunningがtrueなら
                if viewModel.preparationCountDown > 1 || isPreparationTimerRunning {
                    // 以下テキストを表示
                    Text("開始まで\n\(viewModel.preparationCountDown)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.keyWhite))
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                    // 0秒が表示される前に1秒になったら
                } else if viewModel.preparationCountDown == 1 {
                    // その後は表示しない（要は0秒を表示しない）
                }
                // 瞑想中タイマーを表示
                if isMeditatingTimerRunning {
                    Text(viewModel.formattedTime())
                        .foregroundColor(Color(.keyWhite))
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                }
                // isShowStopButtonがtrueなら
                if isShowStopButton {
                    // 中断ボタン
                    Button(action: {
                        // preStartだったら
                        if viewModel.stateModel == .preStart {
                            // prePauseにする
                            viewModel.stateModel = .prePause
                            // startだったら
                        } else if viewModel.stateModel == .start {
                            // pauseにする
                            viewModel.stateModel = .pause
                        }
                        print("中断ボタンが押されたよ")
                        print(viewModel.remainingSeconds)
                    }) {
                        Text("中断する")
                            .tint(Color(.backgroundNavy))
                            .font(.title)
                    }
                    .padding(25)
                    .background(Color(.keyWhite))
                    .cornerRadius(10)
                    .alert("", isPresented: $isShowStopAlert) {
                        // NO
                        Button("NO") {
                            // prePauseだったら
                            if viewModel.stateModel == .prePause {
                                // 開始前残り秒数を格納する
                                viewModel.interruptingPreparationTimer = viewModel.preparationCountDown
                                // preStartにする
                                viewModel.stateModel = .preStart
                                // 瞑想前タイマーを再開
                                viewModel.startPreparationTimer()
                                // pauseだったら
                            } else if viewModel.stateModel == .pause {
                                // 瞑想中残り秒数を格納する
                                viewModel.interruptingMeditationTimer = viewModel.remainingSeconds
                                // startにする
                                viewModel.stateModel = .start
                                // 瞑想タイマーを再開
                                viewModel.startMeditationTimer()
                            }
                        }
                        // YES
                        Button("YES") {
                            viewModel.stopTimer()
                            // 設定画面に戻る
                            dismiss()
                        }
                    } message: {
                        Text("中断して前の画面に戻りますか？")
                    } // .alertここまで
                } // if isShowStopButtonここまで
            } // VStackここまで
        } // ZStack
        .onAppear {
            // 画面起動時にprestart状態にする
            viewModel.stateModel = .preStart
            // 瞑想前タイマーの呼出
            viewModel.startPreparationTimer()
        }
        .onChange(of: viewModel.stateModel) {
            switch viewModel.stateModel {
            case .preStart:
                // ノーを押したらisShowStopAlertをfalseにする
                isShowStopAlert = false
                // 瞑想前タイマーの表示
                isPreparationTimerRunning = true
                // 瞑想タイマーの表示
                isMeditatingTimerRunning = false
            case .prePause:
                // isShowAlertをtrue
                isShowStopAlert = true
            case .start:
                // ノーを押したらisShowStopAlertをfalseにする
                isShowStopAlert = false
                // 瞑想前タイマー非表示
                isPreparationTimerRunning = false
                // 瞑想タイマーの表示
                isMeditatingTimerRunning = true
            case .pause:
                // isShowAlertをtrue
                isShowStopAlert = true
            case .end:
                // 瞑想中タイマーを非表示
                isMeditatingTimerRunning = false
                // 中断ボタン非表示
                isShowStopButton = false
                // 終了アラート表示
                isShowEndAlert = true
            }
            print("プロパティの更新を検知: \(viewModel.stateModel)")
        }
        // 瞑想終了アラート
        .alert("終了", isPresented: $isShowEndAlert) {
            Button("OK") {
                // 設定画面へ戻る
                dismiss()
            }
        } message: {
            Text("おつかれさまでした")
        } // .alertここまで
    } // bodyここまで
} // ContentViewここまで

struct MeditatingView_Previews: PreviewProvider {
    static var previews: some View {
        MeditatingView(viewModel: MeditatingViewModel(selectedMinutes: 1))
    }
}
