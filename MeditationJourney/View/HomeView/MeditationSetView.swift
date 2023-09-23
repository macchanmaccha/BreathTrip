//
//  MeditationSetView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI

struct MeditationSetView: View {
    // Toggleを管理する変数
    @State private var isOn: Bool = false
    // Pickerを管理する変数
    @State private var isShowPicker: Bool = false
    // 選択する時間を管理する変数
    @State private var selectedMinutes: Int = 1
    // 選択する時間
    let minutesOptions: [Int] = [1, 3, 5, 10, 20, 30, 40, 50, 60]
    // Sheetを管理する変数
    @State private var isShowSheet: Bool = false
    // 選択した音を表示する変数
    @State private var selectedSound: String = "ヨーロッパ音楽1"
    var body: some View {
        NavigationStack {
            ZStack {
                ////                 背景色の設定
                               Color.customColor1
                ////                 セーフエリアは無視
                                   .ignoresSafeArea()
                VStack {
                    Spacer()
                    HStack {
                        Text("音声ガイド")
                            .foregroundColor(.customColor)
                            .padding()
                        // 音声ガイドボタン
                        Button(action: {
                            isOn.toggle()
                        }) {
                            Text(isOn ? "ON" : "OFF")
                                .foregroundColor(.customColor1)
                                .padding(9.0)
                                .background(isOn ? Color.customColor : Color.customColor2)
                                .cornerRadius(10)
                        } // Buttonここまで
                    } // HStackここまで
                    .padding()
                    HStack {
                        Text("時間")
                            .foregroundColor(.customColor)
                            .padding()
                        // 時間選択
                        Button(action: {
                            isShowPicker = true
                        }) {
                            Text("\(selectedMinutes)分 ＞")
                                .foregroundColor(.customColor)
                        } // Buttonここまで
                    } // HStackここまで
                    .padding()
                    HStack {
                        Text("音")
                            .foregroundColor(.customColor)
                        // 時間選択
                        Button(action: {
                            isShowSheet = true
                        }) {
                            Text("\(selectedSound)＞")
                                .foregroundColor(.customColor)
                                .padding(9.0)
//                                .background(Color.customColor)
//                                .cornerRadius(10)
                        } // Buttonここまで
                    } // HStackここまで
                    .padding()
                    // はじめるボタン
                    NavigationLink(destination: MeditatingView()) {
                        Text("はじめる")
                            .font(.title)
                            .foregroundColor(.customColor2)
                            .padding(25.0)
                            .background(Color.customColor)
                            .cornerRadius(10)
                    } // NavigationLinkここまで
                    .padding()
                    Spacer()
                    // isShowPickerがtrueのとき
                    if isShowPicker {
                        Picker("時間を選ぶ", selection: $selectedMinutes) {
                            ForEach(minutesOptions, id: \.self) { minutes in
                                Text("\(minutes)分")
                                    .foregroundColor(.customColor)
                            } // if isShowPicker
                        } // Pickerここまで
                        .pickerStyle(WheelPickerStyle())
                        .padding()
                        HStack {
                            Spacer()
                            Button("close") {
                                isShowPicker = false
                            }
                            .padding()
                            .foregroundColor(Color.customColor)
                        } // HStack
                    } // ifここまで
                } // VStackここまで
            } // ZStackここまで
        } // NavigationStackここまで
    }
}

struct MeditationSetView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationSetView()
    }
}
