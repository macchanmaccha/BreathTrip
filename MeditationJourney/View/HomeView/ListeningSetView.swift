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
    /// 選択できる分数
    private let minutesOptions: [Int] = [10, 20, 30, 40, 50, 60, 0]
    var body: some View {
        ZStack {
            Image(.settingsBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            // 背景枠
            Rectangle()
                .fill(.keyWhite)
                .cornerRadius(8)
                .opacity(0.6)
                .frame(width: 400, height: 400)
            VStack {
                Spacer()
                // 時間設定
                HStack {
                    Text("時間")
                        .font(.title2)
                        .foregroundColor(.backgroundNavy)
                    Spacer()
                    Picker("時間を選ぶ", selection: $viewModel.listeningMinutes) {
                        ForEach(minutesOptions, id: \.self) { minute in
                            let minuteText = minute != 0 ? "\(minute)分" : "時間制限なし"
                            Text(minuteText)
                                .tag(minute)
                        }
                    }  // Pickerここまで
                    .colorMultiply(.backgroundNavy)
                    .scaleEffect(CGSize(width: 1.25, height: 1.25))
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: viewModel.listeningMinutes) {
                        viewModel.saveListeningMinutes()
                    }
                }  // HStackここまで
                .foregroundColor(.backgroundNavy)
                .frame(width: 200)
                .padding()
                // 音設定
                HStack {
                    Text("音")
                        .font(.title2)
                        .foregroundColor(.backgroundNavy)
                    Spacer()
                    Button(action: {
                        isShowSheet.toggle()
                    }) {
                        Text("\(viewModel.listeningSoundName.rawValue)>")
                            .font(.title2)
                            .foregroundColor(.backgroundNavy)
                    }
                }  // HStackここまで
                .frame(width: 200)
                .padding()
                // はじめるボタン
                Button(action: {
                    isShowFullScreen.toggle()
                }) {
                    Text("はじめる")
                        .font(.title)
                        .foregroundColor(.keyWhite)
                        .padding(25.0)
                        .background(.backgroundNavy)
                        .cornerRadius(10)
                }
                .fullScreenCover(
                    isPresented: $isShowFullScreen,
                    content: {
                        ListeningView(viewModel: viewModel)
                    }
                )
                .padding()
                Spacer()
            }  // VStackここまで
        }  // ZStackここまで
        .accentColor(.blue)
        // シート
        .sheet(
            isPresented: $isShowSheet,
            content: {
                SelectContinentView(viewModel: viewModel, isShowSheet: $isShowSheet)
            })
    }  // bodyここまで
}  // SoundSetViewここまで

#Preview {
    ListeningSetView()
}
