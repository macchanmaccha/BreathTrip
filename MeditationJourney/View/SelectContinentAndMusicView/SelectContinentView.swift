//
//  SelectContinentView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct SelectContinentView: View {
    // 大陸の配列
    @State private var continents: [String] = ["ヨーロッパ大陸", "オセアニア大陸", "アジア大陸", "アフリカ大陸", "北アメリカ大陸", "南アメリカ大陸"]
    // パネルの配列
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        NavigationStack {
            ZStack {
                Image("IMG_0569")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        GridRow {
                            ForEach(0..<2) { _ in Color.keyWhite }
                        }
                        .frame(width: 150, height: 100)
                        .opacity(0.6)
                        .cornerRadius(8)
                        .padding()
                    } // HStackここまで
                    HStack {
                        GridRow {
                            ForEach(0..<2) { _ in Color.keyWhite }
                        }
                        .frame(width: 150, height: 100)
                        .opacity(0.6)
                        .cornerRadius(8)
                        .padding()
                    } // HStackここまで
                    HStack {
                        GridRow {
                            ForEach(0..<2) { _ in Color.keyWhite }
                        }
                        .frame(width: 150, height: 100)
                        .opacity(0.6)
                        .cornerRadius(8)
                        .padding()
                    } // HStackここまで
                } // VStackここまで
                VStack {
                    HStack {
                        GridRow {
                            ForEach(0..<2) { _ in Color.clear }
                        }
                        .frame(width: 150, height: 100)
                        .opacity(0.6)
                        .cornerRadius(8)
                        .padding()
                    } // HStackここまで
                    HStack {
                        GridRow {
                            ForEach(0..<2) { _ in Color.keyWhite }
                        }
                        .frame(width: 150, height: 100)
                        .opacity(0.6)
                        .cornerRadius(8)
                        .padding()
                    } // HStackここまで
                    HStack {
                        GridRow {
                            ForEach(0..<2) { _ in Color.keyWhite }
                        }
                        .frame(width: 150, height: 100)
                        .opacity(0.6)
                        .cornerRadius(8)
                        .padding()
                    } // HStackここまで
                } // VStackここまで
            } // ZStackここまで
        } // NavigationStackここまで
    } // bodyここまで
} // SelectContinentViewここまで

#Preview {
    SelectContinentView()
}
