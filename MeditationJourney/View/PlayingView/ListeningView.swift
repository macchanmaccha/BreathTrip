//
//  ListeningView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

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
                        // startだったら
                        if viewModel.state == .start {
                            // pauseにする
                            viewModel.updateState(newState: .pause)
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
                            // pauseだったら
                            if viewModel.state == .pause {
                                // startにする
                                viewModel.updateState(newState: .start)
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
            // 画面起動時にstart状態にする
            viewModel.updateState(newState: .start)
        }
        .onChange(of: viewModel.state) {
            switch viewModel.state {
            case .start:
                // 瞑想タイマーの呼出
                viewModel.startListeningTimer()
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
} // ListeningViewここまで

struct ListeningView_Previews: PreviewProvider {
    static var previews: some View {
        ListeningView(viewModel: ListeningSetViewModel())
    }
}
