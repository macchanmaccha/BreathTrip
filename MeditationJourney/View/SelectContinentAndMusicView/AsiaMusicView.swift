//
//  AsiaMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/11.
//

import SwiftUI

struct AsiaMusicView: View {
    @StateObject var viewModel: AsiaMusicViewModel = AsiaMusicViewModel()
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
                                viewModel.getMusic("アジア音1")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("アジア音1")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("アジア音2")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("アジア音2")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                        GridRow {
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("オセアニア音3")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("アジア音3")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("アジア音4")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("アジア音4")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                        GridRow {
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("アジア音5")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("アジア音5")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                                viewModel.getMusic("アジア音6")
                                selectedMusicName = viewModel.selectedMusicName
                            }) {
                                Text("アジア音6")
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
    AsiaMusicView(isShowSheet: Binding.constant(true), selectedMusicName: Binding.constant("アジア音1"))
}
