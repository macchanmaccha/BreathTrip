//
//  SelectContinentMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct SelectSoundView: View {
    // viewModel
    @StateObject var viewModel: ContinentAndSoundViewModel = ContinentAndSoundViewModel()
    // シート変数
    @Binding var isShowSheet: Bool
    // 選択した音の名前を管理する変数
    @Binding var selectedSoundName: SoundModel
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) var dismiss
    // 音Grid
    var columns: [GridItem] = Array(repeating: .init(.fixed(150)), count: 2)
    // 選択した大陸（初期値はヨーロッパ）
    var selectedContinent: ContinentModel = .europe
    var body: some View {
        ZStack {
            Image(.settingsBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer(minLength: 80)
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
                            selectedSoundName = sound
                        }) {
                            Text(sound.rawValue)
                        } // Buttonここまで
                        .frame(width: 130, height: 100)
                        .background(Color(.keyWhite).opacity(0.6))
                        .foregroundColor(Color(.backgroundNavy))
                        .cornerRadius(8)
                    } // ForEacnここまで
                } // LazyVGridここまで
                // LazyVGridの幅を調整
                .frame(maxWidth: 300, alignment: .center)
                .padding(10)
                Spacer(minLength: 80)
            } // VStackここまで
        } // ZStackここまで
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("＜Back")
                        .tint(Color(.keyWhite))
                } // Buttonここまで
            } // ToolbarItemここまで
        } // .toolbarここまで
    } // bodyここまで
}

#Preview {
    SelectSoundView(viewModel: ContinentAndSoundViewModel(), isShowSheet: Binding.constant(true), selectedSoundName: Binding.constant(.europe1), selectedContinent: ContinentModel.europe)
}
