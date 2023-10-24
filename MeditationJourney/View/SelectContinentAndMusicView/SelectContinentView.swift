//
//  SelectContinentView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//
import SwiftUI

struct SelectContinentView: View {
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
                    VStack {
                        Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                            GridRow {
                                NavigationLink(destination: EuropeMusicView()) {
                                    Text("ヨーロッパ大陸")
                                }
                                NavigationLink(destination: OceaniaMusicView()) {
                                    Text("オセアニア大陸")
                                }
                            } // GridRowここまで
                            .frame(width: 130, height: 100)
                            .background(Color.keyWhite.opacity(0.6))
                            .foregroundColor(Color.backgroundNavy)
                            .cornerRadius(8)
                            GridRow {
                                NavigationLink(destination: AsiaMusicView()) {
                                    Text("アジア大陸")
                                }
                                NavigationLink(destination: AfricaMusicView()) {
                                    Text("アフリカ大陸")
                                }
                            } // GridRowここまで
                            .frame(width: 130, height: 100)
                            .background(Color.keyWhite.opacity(0.6))
                            .foregroundColor(Color.backgroundNavy)
                            .cornerRadius(8)
                            GridRow {
                                NavigationLink(destination: NorthAmericaMusicView()) {
                                    Text("北アメリカ大陸")
                                }
                                NavigationLink(destination: SouthAmericaMusicView()) {
                                    Text("南アメリカ大陸")
                                }
                            } // GridRowここまで
                            .frame(width: 130, height: 100)
                            .background(Color.keyWhite.opacity(0.6))
                            .foregroundColor(Color.backgroundNavy)
                            .cornerRadius(8)
                        } // Gridここまで
                    } // VStackここまで
                    Spacer(minLength: 80)
                } // VStackここまで
            } // ZStackここまで
        } // NavigationStackここまで
        .navigationViewStyle(.stack)
    } // bodyここまで
} // SelectContinentViewここまで

#Preview {
    SelectContinentView()
}
