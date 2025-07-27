//
//  MeditationSetView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI

struct MeditationSetView: View {
    /// MeditatingSetViewModelをインスタンス化
    @StateObject private var viewModel: MeditatingSetViewModel = MeditatingSetViewModel()
    /// Sheetを管理する変数
    @State private var isShowSheet: Bool = false
    /// フルスクリーンを管理する変数
    @State private var isShowFullScreen: Bool = false
    /// 音声ガイドToggleを管理する変数
    @AppStorage("audioGuide") private var isAudioGuideOn: Bool = false
    /// 音声ガイドのアイコンを管理
    private var speakerIcon: some View {
        isAudioGuideOn
            ? Image(systemName: "speaker.wave.3.fill") : Image(systemName: "speaker.slash.fill")
    }  // speakerIconここまで
    /// 音声ガイドONOFFを管理する変数
    private var speakerStatusText: Text {
        Text(isAudioGuideOn ? "ON" : "OFF")
    }  // speakerStatusTextここまで
    /// 選択できる分数
    private let minutesOptions: [Int] = [1, 3, 5, 10, 20, 30, 40, 50, 60]
    var body: some View {
        ZStack {
            Image(.settingsBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            // 背景枠
            Rectangle()
                .fill(.keyWhite)
                .cornerRadius(8)
                .opacity(0.6)
                .frame(width: 400, height: 400)
            VStack {
                Spacer()
                HStack {
                    Text("音声ガイド")
                        .font(.title2)
                        .foregroundColor(Color(.backgroundNavy))
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
                        }  // Buttonここまで
                        // ON、OFFのテキスト表示
                        speakerStatusText
                            .frame(width: 30, height: 5)
                            .font(.caption2)
                            .foregroundColor(.backgroundNavy)
                    }  // VStackここまで
                }  // HStackここまで
                .frame(width: 200)
                .padding()
                // 時間設定
                HStack {
                    Text("時間")
                        .font(.title2)
                        .foregroundColor(.backgroundNavy)
                    Spacer()
                    Picker("時間を選ぶ", selection: $viewModel.meditationMinutes) {
                        ForEach(minutesOptions, id: \.self) { minutes in
                            Text("\(minutes)分")
                        }  // ForEachここまで
                    }  // Pickerここまで
                    .colorMultiply(.backgroundNavy)
                    .scaleEffect(CGSize(width: 1.25, height: 1.25))
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: viewModel.meditationMinutes) {
                        viewModel.saveMeditationMinutes()
                    }
                }  // HStackここまで
                .foregroundColor(.backgroundNavy)
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
                        Text("\(viewModel.meditationSoundName.rawValue)>")
                            .font(.title2)
                            .foregroundColor(.backgroundNavy)
                    }
                }  // HStackここまで
                .frame(width: 200)
                .padding()
                // はじめるボタン
                Button(action: {
                    isShowFullScreen.toggle()
                }) {
                    Text("はじめる")
                        .font(.title)
                        .foregroundColor(.keyWhite)
                        .padding(25.0)
                        .background(.backgroundNavy)
                        .cornerRadius(10)
                }
                .fullScreenCover(
                    isPresented: $isShowFullScreen,
                    content: {
                        MeditatingView(viewModel: viewModel)
                    }
                )
                .padding()
                Spacer()
            }  // VStackここまで
        }  // ZStackここまで
        .accentColor(.blue)
        // シート
        .sheet(
            isPresented: $isShowSheet,
            content: {
                SelectContinentView(viewModel: viewModel, isShowSheet: $isShowSheet)
            })
    }  // bodyここまで
}  // MeditationViewここまで

struct MeditationSetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MeditationSetView()
                // ✅ タブの表示名
                .previewDevice(PreviewDevice(rawValue: "iPhone 16"))
                // ✅ プレビューする端末（プレビューデバイス）を指定
                .previewDisplayName("iPhone 16")
            MeditationSetView()
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
                .previewDisplayName("iPad Pro (11-inch)")
        }
    }
}
