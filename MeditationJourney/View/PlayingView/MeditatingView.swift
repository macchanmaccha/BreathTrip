//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import SwiftUI

struct MeditatingView: View {
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) var dismiss
    // viewModel
    @StateObject var viewModel: MeditatingViewModel
    var body: some View {
        ZStack {
            Image("IMG_0571")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                // 瞑想前タイマーが2秒以上もしくはisPreparationTimerRunningがtrueなら
                if viewModel.preparationCountDown > 1 || viewModel.isPreparationTimerRunning {
                    // 以下テキストを表示
                    Text("開始まで\n\(viewModel.preparationCountDown)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.keyWhite)
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                    // 0秒が表示される前に1秒になったら
                } else if viewModel.preparationCountDown == 1 {
                    // その後は表示しない（要は0秒を表示しない）
                }
                // isMeditatingTimerRunningがtrueなら瞑想中タイマーを表示
                if viewModel.isMeditatingTimerRunning {
                    Text(viewModel.formattedTime())
                        .foregroundColor(.keyWhite)
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                } else {
                    // 何も表示しない
                }
                if viewModel.isShowStopButton {
                    // 中断ボタン
                    Button(action: {
                        // 押下するとisShowAlertをtrueにし、アラートを表示
                        viewModel.isShowStopAlert = true
                        print(viewModel.remainingSeconds)
                    }) {
                        Text("中断する")
                            .tint(.backgroundNavy)
                            .font(.title)
                    }
                    .padding(25.0)
                    .background(Color.keyWhite)
                    .cornerRadius(10)
                    .alert("", isPresented: $viewModel.isShowStopAlert) {
                        // NO
                        Button("NO") {
                            // 開始前残り秒数を格納する
                            viewModel.interruptingPreparationTimer = viewModel.preparationCountDown
                            // 瞑想中残り秒数を格納する
                            viewModel.interruptingMeditationTimer = viewModel.remainingSeconds
                            // 瞑想前タイマーを開始もしくは再開
                            viewModel.startPreparationTimer()
                            // 瞑想タイマーを開始もしくは再開
                            viewModel.startMeditationTimer()
                            // ノーを押したらisShowStopAlertをfalseにする
                            viewModel.isShowStopAlert = false
                        }
                        // YES
                        Button("YES") {
                            viewModel.timerHandler?.invalidate()
                            // タイマーを無効に
                            viewModel.timerHandler = nil
                            // 中断アラートをfalse
                            viewModel.isShowStopAlert = false
                            // 前の画面へ
                            dismiss()
                        }
                    } message: {
                        Text("中断して前の画面に戻りますか？")
                    } // .alertここまで
                } else {
                }
            } // VStackここまで
            // 戻るボタンは削除
            .navigationBarBackButtonHidden(true)
            .onAppear {
                // 瞑想前タイマーを表示
                viewModel.isPreparationTimerRunning = true
                // 瞑想前タイマーの呼出
                viewModel.startPreparationTimer()
            }
        } // ZStack
        // 瞑想終了アラート
        .alert("終了", isPresented: $viewModel.isShowEndAlert) {
            Button("OK") {
                // 瞑想設定画面へ戻る
                dismiss()
            }
        } message: {
            Text("おつかれさまでした")
        } // .alertここまで
    } // bodyここまで
} // ContentViewここまで

struct MeditatingView_Previews: PreviewProvider {
    static var previews: some View {
        MeditatingView(viewModel: MeditatingViewModel(selectedMinutes: 1))
    }
}
