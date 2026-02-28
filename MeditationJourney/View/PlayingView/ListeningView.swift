//
//  ListeningView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import AVFoundation
import SwiftUI

struct ListeningView: View {
    // ListeningSetViewModel
    @StateObject var viewModel: ListeningSetViewModel
    // 瞑想中断アラートを管理する変数
    @State private var isShowStopAlert: Bool = false
    // 瞑想終了アラートを管理する変数
    @State private var isShowEndAlert: Bool = false
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Image(.playBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                // 時間無制限の場合
                if viewModel.listeningMinutes == 1440 {
                    Text("∞")
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                } else {
                    // 時間無制限以外の場合
                    Text(Int(viewModel.remainingSeconds).formattedTime())
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                }
                // 中断ボタン
                Button(action: {
                    // pauseにする
                    viewModel.updateTimerState(to: .pause)
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
                        // startにする
                        viewModel.updateTimerState(to: .start)
                    }
                    // YES
                    Button("YES") {
                        // タイマー停止
                        viewModel.stopTimer(timer: &viewModel.selectedDurationMinutesTimer)
                        // 音の再生を完全に停止
                        viewModel.updatePlaybackState(to: SetViewModel.PlaybackState.stop)
                        // 設定画面に戻る
                        dismiss()
                    }
                } message: {
                    Text("中断して前の画面に戻りますか？")
                }  // .alertここまで
            }  // VStackここまで
        }  // ZStack
        /*
         音声割り込みの監視（電話・他アプリが音を奪ったとき）：
         - 音はシステムが自動で止めるが、タイマーは止まらない
         - このため、割り込み通知を受け取ってタイマーも停止する必要がある
         - .began = 割り込み開始 → 一時停止状態に
         - .ended + shouldResume = 再開可能 → 再生再開
         */
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { notification in
            guard let userInfo = notification.userInfo,
                  let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

            switch type {
            case .began:
                if viewModel.timerState == .start {
                    viewModel.updateTimerState(to: .pause)
                }
            case .ended:
                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume), viewModel.timerState == .pause {
                    viewModel.updateTimerState(to: .start)
                }
            @unknown default:
                break
            }
        }
        .onAppear {
            // 一度状態をendにする
            viewModel.updateTimerState(to: .end)
            // その後start状態にする
            viewModel.updateTimerState(to: .start)
        }
        .onChange(of: viewModel.timerState) {
            switch viewModel.timerState {
            case .idle:
                // 何もしない
                break
            case .start:
                // 音の再生を開始
                viewModel.updatePlaybackState(to: SetViewModel.PlaybackState.playing)
                // スリープを無効
                UIApplication.shared.isIdleTimerDisabled = true
            case .pause:
                // タイマー停止・無効
                viewModel.stopTimer(timer: &viewModel.selectedDurationMinutesTimer)
                // 音の再生を一時停止
                viewModel.updatePlaybackState(to: SetViewModel.PlaybackState.pause)
                // isShowAlertをtrue
                isShowStopAlert.toggle()
                // スリープを有効
                UIApplication.shared.isIdleTimerDisabled = false
            case .end:
                // タイマー停止・無効
                viewModel.stopTimer(timer: &viewModel.selectedDurationMinutesTimer)
                // 音の再生を停止
                viewModel.updatePlaybackState(to: SetViewModel.PlaybackState.stop)
                // 終了アラート表示
                isShowEndAlert.toggle()
                // スリープを有効
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
        // 瞑想終了アラート
        .alert("終了", isPresented: $isShowEndAlert) {
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
