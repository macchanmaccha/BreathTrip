//
//  SelectContinentView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//
import SwiftUI

struct SelectContinentView: View {
    @StateObject var viewModel: ContinentAndSoundViewModel = ContinentAndSoundViewModel()
    @Binding var isShowSheet: Bool
    @Binding var selectedSoundName: SoundModel
    // 大陸の配列
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.settingsBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
//                    Spacer(minLength: 80)
                    Text("大陸を選択")
                        .foregroundColor(Color(.keyWhite))
                        .font(.title)
                        .padding()
                    LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                        // 大陸の表示
                        ForEach(viewModel.continents, id: \.self) { continent in
                            // 画面遷移
                            NavigationLink(destination: SelectSoundView(isShowSheet: $isShowSheet, selectedSoundName: $selectedSoundName, selectedContinent: continent)) {
                                // 大陸を1つずつ表示
                                Text(continent.rawValue)
                                    .frame(width: 130, height: 100)
                                    .background(Color(.keyWhite).opacity(0.6))
                                    .foregroundColor(Color(.backgroundNavy))
                                    .cornerRadius(8)
                            } // NavigationLinkここまで
                        } // ForEachここまで
                    } // LazyVGridここまで
                    .frame(maxWidth: 300, alignment: .center) // LazyVGridの幅を調整
                    .padding(10)
//                    Spacer(minLength: 80)
                } // VStackここまで
            } // ZStackここまで
            // 画面遷移後と高さ調整のためテキストをいれておく（意味はなし）
            .navigationTitle(".")
        } // NavigationStackここまで
    } // bodyここまで
} // SelectContinentViewここまで

#Preview {
    SelectContinentView(viewModel: ContinentAndSoundViewModel(), isShowSheet: Binding.constant(true), selectedSoundName: Binding.constant(.europe1))
}
