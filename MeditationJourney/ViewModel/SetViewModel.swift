//
//  SoundSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import SwiftUI

class SetViewModel: ObservableObject {
    // 選択した音を表示する変数
    @AppStorage("selected_Sound") var selectedSoundName: SoundModel = .europe1
    // 選択する時間を管理する変数
    @AppStorage("timer_Value") var selectedMinutes: Int = 10
    // 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published var remainingSeconds: Int = 0
    // タイマー
    var timerHandler: Timer?
    // 音の設定
    func setSelectedSoundName(soundName: SoundModel) {
        selectedSoundName = soundName
    }
} // SoundSetViewModelここまで
