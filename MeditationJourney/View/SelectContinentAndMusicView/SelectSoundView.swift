//
//  SelectContinentMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct SelectSoundView: View {
    @StateObject var viewModel: ContinentAndSoundViewModel = ContinentAndSoundViewModel()
    // シート変数
    @Binding var isShowSheet: Bool
    // 選択した音の名前を管理する変数
    @Binding var selectedMusicName: String
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) var dismiss
    // 音Grid
    var columns: [GridItem] = Array(repeating: .init(.fixed(150)), count: 2)
    var body: some View {
//        NavigationStack {
            ZStack {
                Image("IMG_0569")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer(minLength: 80)
                    Text("音を選択")
                        .foregroundColor(.keyWhite)
                        .font(.title)
                        .padding()
                    Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                        GridRow {
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("ヨーロッパ音1")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("ヨーロッパ音1")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("ヨーロッパ音2")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("ヨーロッパ音2")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                        GridRow {
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("ヨーロッパ音3")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("ヨーロッパ音3")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("ヨーロッパ音4")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("ヨーロッパ音4")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                        GridRow {
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("ヨーロッパ音5")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("ヨーロッパ音5")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("ヨーロッパ音6")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("ヨーロッパ音6")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                    } // Gridここまで
                    Spacer(minLength: 80)
                } // VStackここまで
            } // ZStackここまで
//        } // NavigationStackここまで
//        .navigationViewStyle(.stack)
//        .onAppear {
//            viewModel.fetchMusic()
//        } // .onAppearここまで
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("＜Back")
                        .tint(.keyWhite)
                }
            }
        }
    } // bodyここまで
}

#Preview {
    SelectSoundView(isShowSheet: Binding.constant(true), selectedMusicName: Binding.constant("ヨーロッパ音1"))
}
