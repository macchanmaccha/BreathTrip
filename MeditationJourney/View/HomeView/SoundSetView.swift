//
//  SelectContinentMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct SoundSetView: View {
    // MeditatingSetViewModelをインスタンス化
    @StateObject private var viewModel: MeditatingSetViewModel = MeditatingSetViewModel()
    // Sheetを管理する変数
    @State private var isShowSheet: Bool = false
    // フルスクリーンを管理する変数
    @State private var isShowFullScreen: Bool = false
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
            VStack() {
                Spacer()
                // 音設定
                HStack {
                    Text("音")
                        .font(.title2)
                        .foregroundColor(Color(.backgroundNavy))
                    Spacer()
                    Button(action: {
                        isShowSheet.toggle()
                    }) {
                        Text("\(viewModel.selectedSoundName.rawValue)>")
                            .font(.title2)
                            .foregroundColor(Color(.backgroundNavy))
                    }
                } // HStackここまで
                .frame(width: 200, height: 183)
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
                } // Button
                .fullScreenCover(isPresented: $isShowFullScreen, content: {
                    MeditatingView(viewModel: viewModel)
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
    } // bodyここまで
} // SoundSetViewここまで

#Preview {
    SelectSoundView(viewModel: MeditatingSetViewModel(), isShowSheet: .constant(true), selectedContinent: ContinentModel.europe)
}
