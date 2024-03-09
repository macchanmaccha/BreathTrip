//
//  SoundSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import SwiftUI

class ListeningSetViewModel: ObservableObject {
    // 選択した音を表示する変数
    @AppStorage("selected_Sound") var selectedSoundName: SoundModel = .europe1
    // 選択する時間を管理する変数
    @AppStorage("soundTimer_Value") var selectedMinutes: Int = 10
    var body: some View {
        Text("Hello, ListeningSetViewModel!")
    } // bodyここまで
} // SoundSetViewModelここまで
