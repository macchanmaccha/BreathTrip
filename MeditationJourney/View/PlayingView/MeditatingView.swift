//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import SwiftUI

struct MeditatingView: View {
    // meditatingSetViewModel
    @StateObject var meditatingSetViewModel: MeditatingSetViewModel
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
                // preStartまたはprePauseのとき
                if meditatingSetViewModel.state == .preStart || meditatingSetViewModel.state == .prePause {
                    // 以下テキストを表示
                    Text("開始まで\n\(meditatingSetViewModel.remainingSeconds)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.keyWhite))
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                }
                // 瞑想中タイマーを表示
                if meditatingSetViewModel.state == .start || meditatingSetViewModel.state == .pause {
                    Text(meditatingSetViewModel.formattedTime())
                        .foregroundColor(Color(.keyWhite))
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                }
                // endでないとき
                if meditatingSetViewModel.state != .end {
                    // 中断ボタン
                    Button(action: {
                        // preStartだったら
                        if meditatingSetViewModel.state == .preStart {
                            // prePauseにする
                            meditatingSetViewModel.updateState(newState: .prePause)
                            // startだったら
                        } else if meditatingSetViewModel.state == .start {
                            // pauseにする
                            meditatingSetViewModel.updateState(newState: .pause)
                        }
                        print("中断ボタンが押されたよ")
                        print(meditatingSetViewModel.remainingSeconds)
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
                            if meditatingSetViewModel.state == .prePause {
                                // preStartにする
                                meditatingSetViewModel.updateState(newState: .preStart)
                                // pauseだったら
                            } else if meditatingSetViewModel.state == .pause {
                                // startにする
                                meditatingSetViewModel.updateState(newState: .start)
                            }
                        }
                        // YES
                        Button("YES") {
                            meditatingSetViewModel.stopTimer()
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
            meditatingSetViewModel.updateState(newState: .preStart)
            // 画面起動時に瞑想前タイマー5秒をセットする
            meditatingSetViewModel.setFirstTimer()
        }
        .onChange(of: meditatingSetViewModel.state) {
            switch meditatingSetViewModel.state {
            case .preStart:
                // 瞑想前タイマーの呼出
                meditatingSetViewModel.startPreparationTimer()
            case .prePause:
                // タイマー停止・無効
                meditatingSetViewModel.stopTimer()
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .start:
                // 瞑想タイマーの呼出
                meditatingSetViewModel.startMeditationTimer()
            case .pause:
                // タイマー停止・無効
                meditatingSetViewModel.stopTimer()
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .end:
                // タイマー停止・無効
                meditatingSetViewModel.stopTimer()
                // 終了アラート表示
                isShowEndAlert.toggle()
            }
            print("プロパティの更新を検知: \(meditatingSetViewModel.state)")
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
        MeditatingView(meditatingSetViewModel: MeditatingSetViewModel())
    }
}
