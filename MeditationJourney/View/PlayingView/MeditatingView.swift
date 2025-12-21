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
    @ObservedObject var viewModel: MeditatingSetViewModel
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
                    Text("開始まで\n\(viewModel.remainingSeconds)")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                }
                // 瞑想中タイマーを表示
                if viewModel.timerState == .start || viewModel.timerState == .pause {
                    Text(viewModel.remainingSeconds.formattedTime())
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
                            viewModel.stopTimer()
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
        }
        .onChange(of: viewModel.timerState) {
            switch viewModel.timerState {
            case .preStart:
                // 瞑想前タイマーの呼出
                viewModel.startPreparationTimer()
            case .prePause:
                // タイマー停止・無効
                viewModel.stopTimer()
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .start:
                // 音再生タイマーの呼出
                viewModel.startMeditationTimer()
            case .pause:
                // タイマー停止・無効
                viewModel.stopTimer()
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .end:
                // タイマー停止・無効
                viewModel.stopTimer()
                // 終了アラート表示
                isShowEndAlert.toggle()
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
    // MARK: - Helper Methods
    /// 準備状態かどうか
    private var isPreparationState: Bool {
        viewModel.timerState == .preStart || viewModel.timerState == .prePause
    }
    /// 瞑想状態かどうか
    private var isMeditationState: Bool {
        viewModel.timerState == .start || viewModel.timerState == .pause
    }
    /// 中断ボタンアクション
    private func handleStopButtonAction() {
        switch viewModel.timerState {
        case .preStart:
            viewModel.updateTimerState(to: .prePause)
        case .start:
            viewModel.updateTimerState(to: .pause)
        default:
            break
        }
    }
    /// 中断アラートのNOボタンアクション
    private func handleStopAlertNoAction() {
        switch viewModel.timerState {
        case .prePause:
            viewModel.updateTimerState(to: .preStart)
        case .pause:
            viewModel.updateTimerState(to: .start)
        default:
            break
        }
    }
    /// 中断アラートのYESボタンアクション
    private func handleStopAlertYesAction() {
        viewModel.stopTimer()
        dismiss()
    }
}  // ContentViewここまで

struct MeditatingView_Previews: PreviewProvider {
    static var previews: some View {
        MeditatingView(viewModel: MeditatingSetViewModel())
    }
}
