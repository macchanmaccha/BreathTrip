//
//  SouthAmericaMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/11.
//

import SwiftUI

struct SouthAmericaMusicView: View {
    @StateObject var viewModel: SouthAmericaMusicViewModel = SouthAmericaMusicViewModel()
    // シート変数
    @Binding var isShowSheet: Bool
    // 選択した音の名前を管理する変数
    @Binding var selectedMusicName: String
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) var dismiss
    // 音Grid
    var columns: [GridItem] = Array(repeating: .init(.fixed(150)), count: 2)
    var body: some View {
        NavigationStack {
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
                                viewModel.getMusic("南アメリカ音1")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("南アメリカ音1")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("南アメリカ音2")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("南アメリカ音2")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                        GridRow {
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("南アメリカ音3")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("南アメリカ音3")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("南アメリカ音4")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("南アメリカ音4")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                        GridRow {
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("南アメリカ音5")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("南アメリカ音5")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("南アメリカ音6")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("南アメリカ音6")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                    } // Gridここまで
                    Spacer(minLength: 165)
                } // VStackここまで
            } // ZStackここまで
        } // NavigationStackここまで
        .navigationViewStyle(.stack)
        .onAppear {
            viewModel.fetchMusic()
        }
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
    SouthAmericaMusicView(isShowSheet: Binding.constant(true), selectedMusicName: Binding.constant("南アメリカ音1"))
}
