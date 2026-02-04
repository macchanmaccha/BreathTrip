//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import MusicKit
import SwiftUI

struct MeditatingView: View {
    /// MeditatingSetViewModel
    @StateObject var viewModel: MeditatingSetViewModel
    /// 瞑想中断アラートを管理する変数
    @State private var isShowStopAlert: Bool = false
    /// 瞑想終了アラートを管理する変数
    @State private var isShowEndAlert: Bool = false
    /// 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Image(.playBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                // preStartまたはprePauseのとき
                if viewModel.timerState == .preStart || viewModel.timerState == .prePause {
                    // 以下テキストを表示
                    Text("開始まで\n\(Int(viewModel.remainingSeconds))")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                }
                // 瞑想中タイマーを表示
                if viewModel.timerState == .start || viewModel.timerState == .pause {
                    Text(Int(viewModel.remainingSeconds).formattedTime())
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                } // if
                // endでないとき
                if viewModel.timerState != .end {
                    // 中断ボタン
                    Button(action: {
                        // preStartだったら
                        if viewModel.timerState == .preStart {
                            // prePauseにする
                            viewModel.updateTimerState(to: .prePause)
                            // startだったら
                        } else if viewModel.timerState == .start {
                            // pauseにする
                            viewModel.updateTimerState(to: .pause)
                        }
                    }) {
                        Text("中断する")
                            .tint(.backgroundNavy)
                            .font(.title)
                    }
                    .padding(25)
                    .background(.keyWhite)
                    .cornerRadius(10)
                    .alert("", isPresented: $isShowStopAlert) {
                        // NO
                        Button("NO") {
                            // prePauseだったら
                            if viewModel.timerState == .prePause {
                                // preStartにする
                                viewModel.updateTimerState(to: .preStart)
                                // pauseだったら
                            } else if viewModel.timerState == .pause {
                                // startにする
                                viewModel.updateTimerState(to: .start)
                            }
                        }
                        // YES
                        Button("YES") {
                            // タイマー停止
                            viewModel.stopTimer(timer: &viewModel.selectedDurationMinutesTimer)
                            viewModel.stopTimer(timer: &viewModel.preparationTimer)
                            // 音の再生を完全に停止
                            viewModel.updatePlaybackState(to: SetViewModel.PlaybackState.stopped)
                            // 設定画面に戻る
                            dismiss()
                        }
                    } message: {
                        Text("中断して前の画面に戻りますか？")
                    }  // .alertここまで
                }  // if isShowStopButtonここまで
            }  // VStackここまで
        }  // ZStack
#if DEBUG
        /// デバッグ用：画面タップで終了
        .onTapGesture {
            viewModel.forceEndForDebug()
        }
#endif
        .onAppear {
            // 画面起動時にprestart状態にする
            viewModel.updateTimerState(to: .preStart)
            // 画面起動時に瞑想前タイマー5秒をセットする
            viewModel.setFirstTimer()
            // 表示中はスリープを無効
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // 画面を閉じるときはスリープを有効
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .onChange(of: viewModel.timerState) {
            switch viewModel.timerState {
            case .preStart:
                // 瞑想前タイマーの呼出
                viewModel.startPreparationTimer()
            case .prePause:
                // タイマー停止・無効
                viewModel.stopTimer(timer: &viewModel.selectedDurationMinutesTimer)
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .start:
                // 音の再生を開始
                viewModel.updatePlaybackState(to: SetViewModel.PlaybackState.playing)
            case .pause:
                // タイマー停止・無効
                viewModel.stopTimer(timer: &viewModel.selectedDurationMinutesTimer)
                // 音の再生を一時停止
                viewModel.updatePlaybackState(to: SetViewModel.PlaybackState.paused)
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .end:
                // タイマー停止・無効
                viewModel.stopTimer(timer: &viewModel.selectedDurationMinutesTimer)
                viewModel.stopTimer(timer: &viewModel.preparationTimer)
                // 音の再生を停止
                viewModel.updatePlaybackState(to: SetViewModel.PlaybackState.stopped)
                // 終了アラート表示
                isShowEndAlert.toggle()
            }
        }
        .onChange(of: viewModel.remainingSeconds) { _, newValue in
            // remainingSecondsが5秒になったらフェードアウト
            if newValue > 5 && newValue < 5.1 {
                if let player = viewModel.audioPlayer {
                    viewModel.fadeOut(player: player, duration: 5.0) {
                        viewModel.fadeOutComplete()
                    }
                }
            } else if newValue <= 0 {
                viewModel.updateTimerState(to: .end)
            }
        }
        // 瞑想終了アラート
        .alert("終了", isPresented: $isShowEndAlert) {
            Button("OK") {
                // 保存メソッドを呼び出し
                viewModel.saveMeditationRecord()
                // 設定画面へ戻る
                dismiss()
            }
        } message: {
            Text("おつかれさまでした")
        }  // .alertここまで
    }  // bodyここまで
}  // ContentViewここまで

struct MeditatingView_Previews: PreviewProvider {
    static var previews: some View {
        MeditatingView(viewModel: MeditatingSetViewModel())
    }
}
