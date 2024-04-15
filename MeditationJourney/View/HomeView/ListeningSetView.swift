//
//  SelectContinentMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct ListeningSetView: View {
    /// listeningSetViewModelをインスタンス化
    @StateObject private var viewModel: ListeningSetViewModel = ListeningSetViewModel()
    /// Sheetを管理する変数
    @State private var isShowSheet: Bool = false
    /// フルスクリーンを管理する変数
    @State private var isShowFullScreen: Bool = false
    /// 選択できる分数(UserDefaultsがnilを保持できないため時間制限なしは0)
    private let minutesOptions: [Int] = [10, 20, 30, 40, 50, 60, 0]
    var body: some View {
        ZStack {
            Image(.settingsBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            // 背景枠
            Rectangle()
                .fill(Color(.keyWhite))
                .cornerRadius(8)
                .opacity(0.6)
                .frame(width: 400, height: 400)
            VStack {
                Spacer()
                // 時間設定
                HStack {
                    Text("時間")
                        .font(.title2)
                        .foregroundColor(Color(.backgroundNavy))
                    Spacer()
                    Picker("時間を選ぶ", selection: $viewModel.listeningMinutes) {
                        ForEach(minutesOptions.indices, id: \.self) { index in
                            // 0でないとき
                            if minutesOptions[index] != 0 {
                                Text("\(minutesOptions[index])分")
                                    .tag(minutesOptions[index])
                                // 0のとき（時間制限なしのとき）
                            } else {
                                Text("時間制限なし")
                            }
                        }
                    } // Pickerここまで
                    .colorMultiply(Color(.backgroundNavy))
                    .scaleEffect(CGSize(width: 1.25, height: 1.25))
                    .pickerStyle(MenuPickerStyle())
                } // HStackここまで
                .foregroundColor(Color(.backgroundNavy))
                .frame(width: 200)
                .padding()
                // 音設定
                HStack {
                    Text("音")
                        .font(.title2)
                        .foregroundColor(Color(.backgroundNavy))
                    Spacer()
                    Button(action: {
                        isShowSheet.toggle()
                    }) {
                        Text("\(viewModel.listeningSoundName.rawValue)>")
                            .font(.title2)
                            .foregroundColor(Color(.backgroundNavy))
                    }
                } // HStackここまで
                .frame(width: 200)
                .padding()
                // はじめるボタン
                Button(action: {
                    isShowFullScreen.toggle()
                }) {
                    Text("はじめる")
                        .font(.title)
                        .foregroundColor(Color(.keyWhite))
                        .padding(25.0)
                        .background(Color(.backgroundNavy))
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isShowFullScreen, content: {
                    ListeningView(viewModel: viewModel)
                })
                .padding()
                Spacer()
            } // VStackここまで
        } // ZStackここまで
        .accentColor(.blue)
        // シート
        .sheet(isPresented: $isShowSheet, content: {
            SelectContinentView(viewModel: viewModel, isShowSheet: $isShowSheet)
        })
        .onAppear {
            // 音をきく時の音データを再取得
            viewModel.setSoundModel()
        }
    } // bodyここまで
} // SoundSetViewここまで

#Preview {
    ListeningSetView()
}
