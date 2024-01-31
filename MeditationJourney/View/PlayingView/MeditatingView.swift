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
    @StateObject var viewModel: MeditatingSetViewModel
    // 瞑想中断アラートを管理する変数
    @State private var isShowStopAlert: Bool = false
    // 瞑想終了アラートを管理する変数
    @State private var isShowEndAlert: Bool = false
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
                    Text("開始まで\n\(viewModel.preparationCountDown)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.keyWhite))
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                }
                // 瞑想中タイマーを表示
                if viewModel.state == .start || viewModel.state == .pause {
                    Text(viewModel.formattedTime())
                        .foregroundColor(Color(.keyWhite))
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
                            viewModel.state = .prePause
                            // startだったら
                        } else if viewModel.state == .start {
                            // pauseにする
                            viewModel.state = .pause
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
                            if viewModel.state == .prePause {
                                // 開始前残り秒数を格納する
                                viewModel.interruptingPreparationTimer = viewModel.preparationCountDown
                                // preStartにする
                                viewModel.state = .preStart
                                // 瞑想前タイマーを再開
                                viewModel.startPreparationTimer()
                                // pauseだったら
                            } else if viewModel.state == .pause {
                                // 瞑想中残り秒数を格納する
                                viewModel.interruptingMeditationTimer = viewModel.remainingSeconds
                                // startにする
                                viewModel.state = .start
                                // 瞑想タイマーを再開
                                viewModel.startMeditationTimer()
                            }
                        }
                        // YES
                        Button("YES") {
                            viewModel.state = .end
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
            viewModel.state = .preStart
            // 瞑想前タイマーの呼出
            viewModel.startPreparationTimer()
        }
        .onChange(of: viewModel.state) {
            switch viewModel.state {
            case .preStart: break
            case .prePause:
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .start: break
            case .pause:
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .end:
                // 終了アラート表示
                isShowEndAlert.toggle()
            }
            print("プロパティの更新を検知: \(viewModel.state)")
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
        MeditatingView(viewModel: MeditatingSetViewModel(selectedMinutes: 1))
    }
}
