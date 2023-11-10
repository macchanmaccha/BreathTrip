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
                    Text("大陸を選択")
                        .foregroundColor(.keyWhite)
                        .font(.title)
                        .padding()
                    Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                        GridRow {
                            NavigationLink(destination: EuropeMusicView(isShowSheet: $isShowSheet, selectedMusicName: $selectMusicName)) {
                                Text("ヨーロッパ大陸")
                            }
                            NavigationLink(destination: OceaniaMusicView(isShowSheet: $isShowSheet, selectedMusicName: $selectMusicName)) {
                                Text("オセアニア大陸")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                        GridRow {
                            NavigationLink(destination: AsiaMusicView(isShowSheet: $isShowSheet, selectedMusicName: $selectMusicName)) {
                                Text("アジア大陸")
                            }
                            NavigationLink(destination: AfricaMusicView(isShowSheet: $isShowSheet, selectedMusicName: $selectMusicName)) {
                                Text("アフリカ大陸")
                            }
                        } // GridRowここまで
                        .frame(width: 130, height: 100)
                        .background(Color.keyWhite.opacity(0.6))
                        .foregroundColor(Color.backgroundNavy)
                        .cornerRadius(8)
                        GridRow {
                            NavigationLink(destination: NorthAmericaMusicView(isShowSheet: $isShowSheet, selectedMusicName: $selectMusicName)) {
                                Text("北アメリカ大陸")
                            }
                            NavigationLink(destination: SouthAmericaMusicView(isShowSheet: $isShowSheet, selectedMusicName: $selectMusicName)) {
                                Text("南アメリカ大陸")
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
    } // bodyここまで
} // SelectContinentViewここまで

#Preview {
    SelectContinentView(isShowSheet: Binding.constant(true), selectMusicName: Binding.constant("ヨーロッパ音1"))
}
