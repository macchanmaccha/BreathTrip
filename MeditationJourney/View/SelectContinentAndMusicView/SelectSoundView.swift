//
//  SelectContinentMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct SelectSoundView: View {
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) var dismiss

    // viewModel
    @ObservedObject var viewModel: MeditatingSetViewModel
    // 選択した大陸（初期値はヨーロッパ）
    var selectedContinent: ContinentModel

    // 音Grid
    var columns: [GridItem] = Array(repeating: .init(.fixed(150)), count: 2)

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
                            dismiss()
                            viewModel.selectedSoundName = sound
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
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .tint(Color(.keyWhite))
                } // Buttonここまで
            } // ToolbarItemここまで
        } // .toolbarここまで
    } // bodyここまで
}

struct SelectSoundView_Previews: PreviewProvider {
    static var previews: some View {
        let continent: ContinentModel = .europe

        SelectSoundView(viewModel: MeditatingSetViewModel(), selectedContinent: continent)
    }
}
