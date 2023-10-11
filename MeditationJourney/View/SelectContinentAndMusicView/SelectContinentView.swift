//
//  SelectContinentView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct SelectContinentView: View {
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Image("IMG_0569")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("大陸を選択")
                            .foregroundColor(.keyWhite)
                            .font(.title)
                        Grid {
                            GridRow {
                                ForEach(0..<2) { _ in Color.keyWhite }
                            } // GridRowここまで
                            .frame(width: 150, height: 100)
                            .cornerRadius(8)
                            .opacity(0.6)
                            .padding()
                        } // Gridここまで
                        Grid {
                            GridRow {
                                ForEach(0..<2) { _ in Color.keyWhite }
                            } // GridRowここまで
                            .frame(width: 150, height: 100)
                            .cornerRadius(8)
                            .opacity(0.6)
                            .padding()
                        } // Gridここまで
                        Grid {
                            GridRow {
                                ForEach(0..<2) { _ in Color.keyWhite }
                            } // GridRowここまで
                            .frame(width: 150, height: 100)
                            .cornerRadius(8)
                            .opacity(0.6)
                            .padding()
                        } // Gridここまで
                    } // VStack
                    VStack {
                        HStack {
                            NavigationLink(destination: EuropeMusicView()) {
                                Text("ヨーロッパ大陸")
                                    .font(.title2)
                                    .foregroundColor(.backgroundNavy)
                                    .multilineTextAlignment(.leading)
                            } // NavigationLinkここまで
                            .frame(width: 180, height: 130)
                            NavigationLink(destination: OceaniaMusicView()) {
                                Text("オセアニア大陸")
                                    .font(.title2)
                                    .foregroundColor(.backgroundNavy)
                                    .multilineTextAlignment(.leading)
                            } // NavigationLinkここまで
                            .frame(width: 180, height: 130)
                        } // HStackここまで
                        HStack {
                            NavigationLink(destination: AsiaMusicView()) {
                                Text("アジア大陸")
                                    .font(.title2)
                                    .foregroundColor(.backgroundNavy)
                                    .multilineTextAlignment(.leading)
                            } // NavigationLinkここまで
                            .frame(width: 180, height: 130)
                            NavigationLink(destination: AfricaMusicView()) {
                                Text("アフリカ大陸")
                                    .font(.title2)
                                    .foregroundColor(.backgroundNavy)
                                    .multilineTextAlignment(.leading)
                            } // NavigationLinkここまで
                            .frame(width: 180, height: 130)
                        } // HStackここまで
                        HStack {
                            NavigationLink(destination: NorthAmericaMusicView()) {
                                Text("北アメリカ大陸")
                                    .font(.title2)
                                    .foregroundColor(.backgroundNavy)
                                    .multilineTextAlignment(.leading)
                            } // NavigationLinkここまで
                            .frame(width: 180, height: 130)
                            NavigationLink(destination: SouthAmericaMusicView()) {
                                Text("南アメリカ大陸")
                                    .font(.title2)
                                    .foregroundColor(.backgroundNavy)
                                    .multilineTextAlignment(.leading)
                            } // NavigationLinkここまで
                            .frame(width: 180, height: 130)
                        } // HStackここまで
                    } // VStackここまで
                    .padding(.top, 50)
                } // ZStackここまで
            } // VStackここまで
        }
    } // bodyここまで
} // SelectContinentViewここまで

#Preview {
    SelectContinentView()
}
