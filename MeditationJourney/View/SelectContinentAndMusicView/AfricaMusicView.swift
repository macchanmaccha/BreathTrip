//
//  AfricaMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/11.
//

import SwiftUI

struct AfricaMusicView: View {
    @StateObject var viewModel: AfricaMusicViewModel = AfricaMusicViewModel()
    // シート変数
    @Binding var isShowSheet: Bool
    // 選択した音の名前を管理する変数
    @Binding var selectedMusicName: String
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
                            }) {
                                Text("アフリカ音1")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                            }) {
                                Text("アフリカ音2")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                        GridRow {
                            Button(action: {
                                isShowSheet.toggle()
                            }) {
                                Text("アフリカ音3")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                            }) {
                                Text("アフリカ音4")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                        GridRow {
                            Button(action: {
                                isShowSheet.toggle()
                            }) {
                                Text("アフリカ音5")
                            }
                            Button(action: {
                                isShowSheet.toggle()
                            }) {
                                Text("アフリカ音6")
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
        } // NavigationStackここまで
        .navigationViewStyle(.stack)
        .onAppear {
            viewModel.fetchMusic()
        }
    } // bodyここまで
}

#Preview {
    AfricaMusicView(isShowSheet: Binding.constant(true), selectedMusicName: Binding.constant("アフリカ音1"))
}
