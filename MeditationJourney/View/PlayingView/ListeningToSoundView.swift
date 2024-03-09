//
//  ListeningToSoundView.swift
//  MeditationJourney
//
//  Created by apple on 2024/01/06.
//

import SwiftUI

struct ListeningToSoundView: View {
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) var dismiss
    // viewModel
    @StateObject var viewModel: ListeningToSoundViewModel
    var body: some View {
        ZStack {
            Image(.playBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if viewModel.isShowStopButton {
                    // 中断ボタン
                    Button(action: {
                        // 押下するとisShowAlertをtrueにし、アラートを表示
                        viewModel.isShowStopAlert = true
                        print(viewModel.remainingSeconds)
                    }) {
                        Text("中断する")
                            .tint(Color(.backgroundNavy))
                            .font(.title)
                    }
                    .padding(25)
                    .background(Color(.keyWhite))
                    .cornerRadius(10)
                    .alert("", isPresented: $viewModel.isShowStopAlert) {
                        // NO
                        Button("NO") {
                            // ノーを押したらisShowStopAlertをfalseにする
                            viewModel.isShowStopAlert = false
                        }
                        // YES
                        Button("YES") {
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
        } // ZStack
    } // bodyここまで
}
struct ListeningToSoundView_Previews: PreviewProvider {
    static var previews: some View {
        MeditatingView(viewModel: MeditatingViewModel(selectedMinutes: 1))
    }
}
