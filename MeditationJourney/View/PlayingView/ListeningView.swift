//
//  ListeningView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import AVFoundation
import SwiftUI

struct ListeningView: View {
    /// ListeningSetViewModel
    @ObservedObject var viewModel: ListeningSetViewModel
    /// 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) private var dismiss
    /// アプリの状態（バックグラウンド検知用）
    @Environment(\.scenePhase) private var scenePhase
    /// 時間無制限のプロパティ 一律で1440分（60分×24時間）
    let isUnlimitedTime: Int = 1440
    var body: some View {
        ZStack {
            Image(.playBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                // 時間無制限の場合
                if viewModel.listeningMinutes == isUnlimitedTime {
                    Text("∞")
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                    // 時間無制限以外の場合
                } else {
                    Text(Int(viewModel.remainingSeconds).formattedTime())
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                }
                // endでないとき、かつ終了状態で画面離脱した場合（suspended + stateBeforeLeaving == end）以外
                if viewModel.shouldShowInterruptButton {
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
                            dismiss()
                        }
                    } message: {
                        Text("中断して前の画面に戻りますか？")
                    }  // .alertここまで
                }  // if
            }  // VStackここまで
        }  // ZStack
        .onAppear {
            viewModel.onViewAppear()
        }
        // 画面離脱時の処理
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
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
        .alert("終了", isPresented: $viewModel.isShowEndAlert) {
            Button("OK") {
                // 設定画面へ戻る
                dismiss()
            }
        } message: {
            Text("終了です")
        }  // .alertここまで
    }  // bodyここまで
}  // ListeningViewここまで

struct ListeningView_Previews: PreviewProvider {
    static var previews: some View {
        ListeningView(viewModel: ListeningSetViewModel())
    }
}
