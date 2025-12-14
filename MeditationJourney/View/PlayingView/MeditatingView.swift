//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

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
                if viewModel.state == .preStart || viewModel.state == .prePause {
                    // 以下テキストを表示
                    Text("開始まで\n\(viewModel.remainingSeconds)")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                }
                // 瞑想中タイマーを表示
                if viewModel.state == .start || viewModel.state == .pause {
                    Text(viewModel.remainingSeconds.formattedTime())
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                }
                // endでないとき
                if viewModel.state != .end {
                    // 中断ボタン
                    Button(action: {
                        // preStartだったら
                        if viewModel.state == .preStart {
                            // prePauseにする
                            viewModel.updateState(to: .prePause)
                            // startだったら
                        } else if viewModel.state == .start {
                            // pauseにする
                            viewModel.updateState(to: .pause)
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
                            if viewModel.state == .prePause {
                                // preStartにする
                                viewModel.updateState(to: .preStart)
                                // pauseだったら
                            } else if viewModel.state == .pause {
                                // startにする
                                viewModel.updateState(to: .start)
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
            viewModel.updateState(to: .preStart)
            // 画面起動時に瞑想前タイマー5秒をセットする
            viewModel.setFirstTimer()
        }
        .onChange(of: viewModel.state) {
            switch viewModel.state {
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
        viewModel.state == .preStart || viewModel.state == .prePause
    }
    /// 瞑想状態かどうか
    private var isMeditationState: Bool {
        viewModel.state == .start || viewModel.state == .pause
    }
    /// 中断ボタンアクション
    private func handleStopButtonAction() {
        switch viewModel.state {
        case .preStart:
            viewModel.updateState(to: .prePause)
        case .start:
            viewModel.updateState(to: .pause)
        default:
            break
        }
    }
    /// 中断アラートのNOボタンアクション
    private func handleStopAlertNoAction() {
        switch viewModel.state {
        case .prePause:
            viewModel.updateState(to: .preStart)
        case .pause:
            viewModel.updateState(to: .start)
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
