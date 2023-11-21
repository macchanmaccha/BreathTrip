//
//  SelectContinentView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//
import SwiftUI

struct SelectContinentView: View {
    @Binding var isShowSheet: Bool
    @Binding var selectMusicName: String
    @StateObject var  continentAndSoundViewModel: ContinentAndSoundViewModel = ContinentAndSoundViewModel()
    // 6個のパネルを管理する配列
    @State private var moves: [String] = Array(repeating: "", count: 9)
    // パネルの数字（0〜8）
    @State private var panels: [Int] = Array(0...5)
    // パネルの配列
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var continentName: String = ""
    var body: some View {
        NavigationStack {
            ZStack {
                Image("IMG_0569")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer(minLength: 80)
                    Text("大陸を選択")
                        .foregroundColor(.keyWhite)
                        .font(.title)
                        .padding()
                    LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                        // 大陸の表示
                        ForEach(continentAndSoundViewModel.continents, id: \.self) { continent in
                            NavigationLink(destination: SelectSoundView(isShowSheet: $isShowSheet, selectedMusicName: $selectMusicName)) {
                                Text(continent.rawValue)
                                    .frame(width: 130, height: 100)
                                    .background(Color.keyWhite.opacity(0.6))
                                    .foregroundColor(Color.backgroundNavy)
                                    .cornerRadius(8)
                            }
                        } // ForEacnここまで
                    } // LazyVGridここまで
                    .frame(maxWidth: 300, alignment: .center) // LazyVGridの幅を調整
                    .padding(10)
                    Spacer(minLength: 80)
                } // VStackここまで
            } // ZStackここまで
            //            .navigationTitle("")
        } // NavigationStackここまで
        .navigationViewStyle(.stack)
    } // bodyここまで
} // SelectContinentViewここまで

#Preview {
    SelectContinentView(isShowSheet: Binding.constant(true), selectMusicName: Binding.constant("ヨーロッパ音1"))
}
