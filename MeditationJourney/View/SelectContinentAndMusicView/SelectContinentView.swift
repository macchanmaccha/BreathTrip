//
//  SelectContinentView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//
import SwiftUI

struct SelectContinentView: View {
    /// viewModel
    @StateObject var viewModel: SetViewModel
    /// isShowSheet
    @Binding var isShowSheet: Bool
    /// 大陸の配列
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.settingsBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("大陸を選択")
                        .foregroundColor(.keyWhite)
                        .font(.title)
                        .padding()
                    LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                        // 大陸の表示
                        ForEach(ContinentModel.allCases, id: \.self) { continent in
                            // 画面遷移
                            NavigationLink(
                                destination: SelectSoundView(
                                    viewModel: viewModel, isShowSheet: $isShowSheet,
                                    selectedContinent: continent)
                            ) {
                                // 大陸を1つずつ表示
                                Text(continent.rawValue)
                                    .frame(width: 130, height: 100)
                                    .background(.keyWhite.opacity(0.6))
                                    .foregroundColor(.backgroundNavy)
                                    .cornerRadius(8)
                            }  // NavigationLinkここまで
                        }  // ForEachここまで
                    }  // LazyVGridここまで
                    .frame(maxWidth: 300, alignment: .center)  // LazyVGridの幅を調整
                    .padding(10)
                }  // VStackここまで
            }  // ZStackここまで
            // シートを閉じる
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowSheet.toggle()
                    }) {
                        Image(systemName: "xmark")
                            .tint(.keyWhite)
                    }  // Buttonここまで
                }  // ToolbarItemここまで
            }  // .toolbarここまで
        }  // NavigationStackここまで
    }  // bodyここまで
}  // SelectContinentViewここまで

#Preview {
    SelectContinentView(viewModel: SetViewModel(), isShowSheet: .constant(true))
}
