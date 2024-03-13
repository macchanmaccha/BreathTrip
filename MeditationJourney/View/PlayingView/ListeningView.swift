//
//  ListeningView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import SwiftUI

struct ListeningView: View {
    // meditatingSetViewModel
    @StateObject var listeningSetViewModel: ListeningSetViewModel
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
                if listeningSetViewModel.state == .start || listeningSetViewModel.state == .pause {
                    // 以下テキストを表示
                    Text("開始まで\n\(listeningSetViewModel.remainingSeconds)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.keyWhite))
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                }
                // 瞑想中タイマーを表示
                if listeningSetViewModel.state == .start || listeningSetViewModel.state == .pause {
                    Text(listeningSetViewModel.formattedTime())
                        .foregroundColor(Color(.keyWhite))
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                }
                // endでないとき
                if listeningSetViewModel.state != .end {
                    // 中断ボタン
                    Button(action: {
                        // preStartだったら
                        if listeningSetViewModel.state == .start {
                            // prePauseにする
                            listeningSetViewModel.updateState(newState: .pause)
                            // startだったら
                        }
                        print("中断ボタンが押されたよ")
                        print(listeningSetViewModel.remainingSeconds)
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
                            // pauseだったら
                            if listeningSetViewModel.state == .pause {
                                // startにする
                                listeningSetViewModel.updateState(newState: .start)
                            }
                        }
                        // YES
                        Button("YES") {
                            listeningSetViewModel.stopTimer()
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
            listeningSetViewModel.updateState(newState: .start)
        }
        .onChange(of: listeningSetViewModel.state) {
            switch listeningSetViewModel.state {
            case .start:
//                // 瞑想タイマーの呼出
//                listeningSetViewModel.startMeditationTimer()
                listeningSetViewModel.formattedTime()
            case .pause:
                // タイマー停止・無効
                listeningSetViewModel.stopTimer()
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .end:
                // タイマー停止・無効
                listeningSetViewModel.stopTimer()
                // 終了アラート表示
                isShowEndAlert.toggle()
            }
            print("プロパティの更新を検知: \(listeningSetViewModel.state)")
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
} // ListeningViewここまで

struct ListeningView_Previews: PreviewProvider {
    static var previews: some View {
        ListeningView(listeningSetViewModel: ListeningSetViewModel())
    }
}
