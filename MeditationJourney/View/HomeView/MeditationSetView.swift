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
    // 選択する時間を管理する変数
    @State private var selectedMinutes: Int = 1
    // 選択する時間
    let minutesOptions: [Int] = [1, 3, 5, 10, 20, 30, 40, 50, 60]
    // 選択した時間の文字色を設定する変数
    @State private var selectMinitesTextColor: Int = 0
    // イニシャライザ
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.red], for: .selected)
    } // initここまで
    // Sheetを管理する変数
    @State private var isShowSheet: Bool = false
    // 選択した音を表示する変数
    @State private var selectedSound: String = "音1"
    var body: some View {
        NavigationStack {
            ZStack {
                Image("IMG_0569")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                // 背景枠
                Rectangle()
                    .fill(Color.customColor)
                    .cornerRadius(8)
                    .opacity(0.6)
                    .frame(width: 400, height: 400)
                VStack {
                    Spacer()
                    HStack {
                        Text("音声ガイド")
                            .font(.title2)
                            .foregroundColor(.customColor1)
                        Spacer()
                        VStack {
                            // 音声ガイドボタン
                            Button(action: {
                                isOn.toggle()
                            }) {
                                if isOn {
                                    Image(systemName: "speaker.wave.3.fill")
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.customColor1)
                                        .font(.title)
                                } else {
                                    Image(systemName: "speaker.slash.fill")
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.customColor1)
                                        .font(.title)
                                } // ifここまで
                            } // Buttonここまで
                            if isOn {
                                Text("ON")
                                    .frame(width: 30, height: 5)
                                    .font(.caption2)
                                    .foregroundColor(.customColor1)
                            } else {
                                Text("OFF")
                                    .frame(width: 30, height: 5)
                                    .font(.caption2)
                                    .foregroundColor(.customColor1)
                            } // ifここまで
                        } // VStackここまで
                    } // HStackここまで
                    .frame(width: 200)
                    .padding()
                    // 時間設定
                    HStack {
                        Text("時間")
                            .font(.title2)
                            .foregroundColor(.customColor1)
                        Spacer()
                        Picker("時間を選ぶ", selection: $selectedMinutes) {
                            ForEach(minutesOptions, id: \.self) { minutes in
                                Text("\(minutes)分")
                            } // if isShowPicker
                        } // Pickerここまで
                        .colorMultiply(.customColor1)
                        .scaleEffect(CGSize(width: 1.25, height: 1.25))
                        .pickerStyle(MenuPickerStyle())
                    } // HStackここまで
                    .foregroundColor(Color.customColor1)
                    .frame(width: 200)
                    .padding()
                    // 音設定
                    HStack {
                        Text("音")
                            .font(.title2)
                            .foregroundColor(.customColor1)
                        Spacer()
                        NavigationLink(destination: SelectContinentView()) {
                            Text("音1＞")
                                .font(.title2)
                                .foregroundColor(.customColor1)
                        } // NavigationLinkここまで
                    } // HStackここまで
                    .frame(width: 200)
                    .padding()
                    // はじめるボタン
                    NavigationLink(destination: MeditatingView()) {
                        Text("はじめる")
                            .font(.title)
                            .foregroundColor(.customColor)
                            .padding(25.0)
                            .background(Color.customColor1)
                            .cornerRadius(10)
                    } // NavigationLinkここまで
                    .padding()
                    Spacer()
                } // VStackここまで
            } // ZStackここまで
        } // NavigationStackここまで
    }
}

struct MeditationSetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MeditationSetView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15"))  // ✅ タブの表示名
                .previewDisplayName("iPhone 15")  // ✅ プレビューする端末（プレビューデバイス）を指定
            MeditationSetView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
                .previewDisplayName("iPad Air (5th generation)")
        }
    }
}
