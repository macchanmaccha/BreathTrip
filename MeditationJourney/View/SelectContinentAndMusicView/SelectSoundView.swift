//
//  SelectContinentMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct SelectSoundView: View {
    /// setViewModel
    @StateObject var viewModel: SetViewModel
    /// isShowSheet
    @Binding var isShowSheet: Bool
    /// 選択した大陸
    let selectedContinent: ContinentModel
    /// 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) private var dismiss
    /// 音Grid
    private let columns: [GridItem] = Array(repeating: .init(.fixed(150)), count: 2)
    var body: some View {
        ZStack {
            Image(.settingsBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("音を選択")
                    .foregroundColor(Color(.keyWhite))
                    .font(.title)
                    .padding()
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    // 音の表示
                    ForEach(selectedContinent.soundList, id: \.self) { sound in
                        Button(action: {
                            // 音を再生するなどのアクションを実行
                            isShowSheet.toggle()
                            viewModel.setSelectedSoundName(soundName: sound)
                        }) {
                            Text(sound.rawValue)
                        } // Buttonここまで
                        .frame(width: 130, height: 100)
                        .background(Color(.keyWhite).opacity(0.6))
                        .foregroundColor(Color(.backgroundNavy))
                        .cornerRadius(8)
                    } // ForEachここまで
                } // LazyVGridここまで
                // LazyVGridの幅を調整
                .frame(maxWidth: 300, alignment: .center)
                .padding(10)
            } // VStackここまで
        } // ZStackここまで
        .navigationBarBackButtonHidden(true)
        // 前画面へ戻る
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .tint(Color(.keyWhite))
                } // Buttonここまで
            } // ToolbarItemここまで
            // シートを閉じる
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isShowSheet.toggle()
                }) {
                    Image(systemName: "xmark")
                        .tint(Color(.keyWhite))
                } // Buttonここまで
            } // ToolbarItemここまで
        } // .toolbarここまで
    } // bodyここまで
}

#Preview {
    SelectSoundView(viewModel: SetViewModel(), isShowSheet: .constant(true), selectedContinent: ContinentModel.europa)
}
