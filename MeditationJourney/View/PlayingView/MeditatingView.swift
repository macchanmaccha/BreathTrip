//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import AVFoundation
import MusicKit
import SwiftUI

struct MeditatingView: View {
    /// MeditatingSetViewModel
    @ObservedObject var viewModel: MeditatingSetViewModel
    /// 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) private var dismiss
    /// アプリの状態（バックグラウンド検知用）
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        ZStack {
            Image(.playBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                // preStart、prePause、またはpreStart時に画面離脱した場合（suspendedかつstateBeforeLeavingがpreStart/prePause）のみ表示
                if viewModel.timerState == .preStart || viewModel.timerState == .prePause {
                    Text("開始まで\n\(Int(viewModel.remainingSeconds))")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                } else if viewModel.timerState == .suspended,
                          let state = viewModel.stateBeforeLeaving,
                          state == .preStart || state == .prePause {
                    Text("開始まで\n\(Int(viewModel.remainingSeconds))")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                }
                // 瞑想中タイマーを表示
                if viewModel.timerState == .start || viewModel.timerState == .pause || viewModel.timerState == .suspended && viewModel.stateBeforeLeaving == .start {
                    Text(Int(viewModel.remainingSeconds).formattedTime())
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                } // if
                // endでないとき、かつ終了状態で画面離脱した場合（suspended + stateBeforeLeaving == end）以外
                if viewModel.timerState != .end && !(viewModel.timerState == .suspended && viewModel.stateBeforeLeaving == .end) {
                    // 中断ボタン
                    Button(action: {
                        viewModel.onInterruptButtonTapped()
                    }) {
                        Text("中断する")
                            .tint(.backgroundNavy)
                            .font(.title)
                    }
                    .padding(25)
                    .background(.keyWhite)
                    .cornerRadius(10)
                    .alert("", isPresented: $viewModel.isShowStopAlert) {
                        // NO
                        Button("NO") {
                            viewModel.onInterruptAlertNoTapped()
                        }
                        // YES
                        Button("YES") {
                            viewModel.onInterruptAlertYesTapped()
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
            viewModel.onViewAppear()
        }
        // 画面離脱時の処理
        .onChange(of: scenePhase) { _, newPhase in
            // 画面離脱時の処理
            if newPhase == .background {
                // 画面離脱時は例外なくどの状態であってもsuspendedにする
                viewModel.updateBackground(to: .suspended)
            }
        } // .onChange(of: scenePhase)ここまで
        .onChange(of: viewModel.timerState) {
            viewModel.updateTimer()
        }
        /// 音声割り込みの監視（着信及び緊急時の割り込み）
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { notification in
            viewModel.updateInterruption(notification: notification)
        }
        .onChange(of: viewModel.remainingSeconds) { _, newValue in
            viewModel.onRemainingSecondsChanged(newValue: newValue)
        }
        // 瞑想終了アラート
        .alert("終了", isPresented: $viewModel.isShowEndAlert) {
            Button("OK") {
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
