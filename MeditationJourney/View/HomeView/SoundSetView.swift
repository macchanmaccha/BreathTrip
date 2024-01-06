//
//  SoundSetView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI

struct SoundSetView: View {
    // Sheetを管理する変数
    @State private var isShowSheet: Bool = false
    // 選択する時間を管理する変数
    @AppStorage("timer_Value") var selectedMinutes: Int = 1
    // 選択した音を表示する変数
    @AppStorage("selected_SoundName") var selectedSoundName: SoundModel = .europe1
    // MinutesModel
    @State var model: MinutesModel = MinutesModel()
    // フルスクリーンを管理する変数
    @State var isShowFullScreen: Bool = false
    var body: some View {
        ZStack {
            Image(.settingsBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            // 背景枠
            Rectangle()
                .fill(Color(.keyWhite))
                .cornerRadius(8)
                .opacity(0.6)
                .frame(width: 400, height: 400)
            VStack {
                Spacer()
                // 時間設定
                HStack {
                    Text("時間")
                        .font(.title2)
                        .foregroundColor(Color(.backgroundNavy))
                    Spacer()
                    Picker("時間を選ぶ", selection: $selectedMinutes) {
                        ForEach(model.minutesOptions, id: \.self) { minutes in
                            Text("\(minutes)分")
                        } // ForEachここまで
                    } // Pickerここまで
                    .colorMultiply(Color(.backgroundNavy))
                    .scaleEffect(CGSize(width: 1.25, height: 1.25))
                    .pickerStyle(MenuPickerStyle())
                } // HStackここまで
                .foregroundColor(Color(.backgroundNavy))
                .frame(width: 200)
                .padding()
                // 音設定
                HStack {
                    Text("音")
                        .font(.title2)
                        .foregroundColor(Color(.backgroundNavy))
                    Spacer()
                    Button(action: {
                        isShowSheet.toggle()
                    }) {
                        Text("\(selectedSoundName.rawValue)>")
                            .font(.title2)
                            .foregroundColor(Color(.backgroundNavy))
                    }
                } // HStackここまで
                .frame(width: 200)
                .padding()
                // はじめるボタン
                Button(action: {
                    isShowFullScreen.toggle()
                }) {
                    Text("はじめる")
                        .font(.title)
                        .foregroundColor(Color(.keyWhite))
                        .padding(25)
                        .background(Color(.backgroundNavy))
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isShowFullScreen, content: {
                    ListeningToSoundView()
                })
                .padding()
                Spacer()
            } // VStackここまで
        } // ZStackここまで
        .accentColor(.blue)
        // シート
        .sheet(isPresented: $isShowSheet, content: {
            SelectContinentView(isShowSheet: $isShowSheet, selectedSoundName: $selectedSoundName)
        })
    } // bodyここまで
} // MeditationViewここまで

struct SoundSetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SoundSetView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15"))  // ✅ タブの表示名
                .previewDisplayName("iPhone 15")  // ✅ プレビューする端末（プレビューデバイス）を指定
            SoundSetView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
                .previewDisplayName("iPad Air (5th generation)")
        }
    }
}
