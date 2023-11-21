//
//  MeditationSetView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI

struct MeditationSetView: View {
    // Sheetを管理する変数
    @State private var isShowSheet: Bool = false
    // 音声ガイドToggleを管理する変数
    @State private var isAudioGuideOn: Bool = false
    // 選択する時間を管理する変数
    @State private var selectedMinutes: Int = 1
    // 選択した音を表示する変数
    @State private var selectedMusicName: String = "ヨーロッパ音1"
    // 選択する時間
    private let minutesOptions: [Int] = [1, 3, 5, 10, 20, 30, 40, 50, 60]
    // 音声ガイドのアイコンを管理
    private var speakerIcon: some View {
        isAudioGuideOn ? Image(systemName: "speaker.wave.3.fill") :
        Image(systemName: "speaker.slash.fill")
    } // speakerIconここまで
    // 音声ガイドONOFFを管理する変数
    private var speakerStatusText: Text {
        Text(isAudioGuideOn ? "ON" : "OFF")
    } // speakerStatusTextここまで
    var body: some View {
        NavigationStack {
            ZStack {
                Image("IMG_0569")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                // 背景枠
                Rectangle()
                    .fill(Color.keyWhite)
                    .cornerRadius(8)
                    .opacity(0.6)
                    .frame(width: 400, height: 400)
                VStack {
                    Spacer()
                    HStack {
                        Text("音声ガイド")
                            .font(.title2)
                            .foregroundColor(.backgroundNavy)
                        Spacer()
                        VStack {
                            // 音声ガイドボタン
                            Button(action: {
                                isAudioGuideOn.toggle()
                            }) {
                                // 音声ガイドアイコン
                                speakerIcon
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.backgroundNavy)
                                    .font(.title)
                            } // Buttonここまで
                            // ON、OFFのテキスト表示
                            speakerStatusText
                                .frame(width: 30, height: 5)
                                .font(.caption2)
                                .foregroundColor(.backgroundNavy)
                        } // VStackここまで
                    } // HStackここまで
                    .frame(width: 200)
                    .padding()
                    // 時間設定
                    HStack {
                        Text("時間")
                            .font(.title2)
                            .foregroundColor(.backgroundNavy)
                        Spacer()
                        Picker("時間を選ぶ", selection: $selectedMinutes) {
                            ForEach(minutesOptions, id: \.self) { minutes in
                                Text("\(minutes)分")
                            } // ForEachここまで
                        } // Pickerここまで
                        .colorMultiply(.backgroundNavy)
                        .scaleEffect(CGSize(width: 1.25, height: 1.25))
                        .pickerStyle(MenuPickerStyle())
                    } // HStackここまで
                    .foregroundColor(Color.backgroundNavy)
                    .frame(width: 200)
                    .padding()
                    // 音設定
                    HStack {
                        Text("音")
                            .font(.title2)
                            .foregroundColor(.backgroundNavy)
                        Spacer()
                        Button(action: {
                            isShowSheet.toggle()
                        }) {
                            Text(selectedMusicName)
                                .font(.title2)
                                .foregroundColor(.backgroundNavy)
                        }
                    } // HStackここまで
                    .frame(width: 200)
                    .padding()
                    // はじめるボタン
                    NavigationLink(destination: MeditatingView()) {
                        Text("はじめる")
                            .font(.title)
                            .foregroundColor(.keyWhite)
                            .padding(25.0)
                            .background(Color.backgroundNavy)
                            .cornerRadius(10)
                    } // NavigationLinkここまで
                    .padding()
                    Spacer()
                } // VStackここまで
            } // ZStackここまで
        } // NavigationStack
        .accentColor(.blue)
        // シート
        .sheet(isPresented: $isShowSheet, content: {
            SelectContinentView(isShowSheet: $isShowSheet, selectMusicName: $selectedMusicName)
        })
    } // bodyここまで
} // MeditationViewここまで

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
