//
//  SoundSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import SwiftUI

class ListeningSetViewModel: SetViewModel {
    // 音をきく画面での状態　初期値はend
    @Published private(set) var state: State = .end
    enum State {
        case start     // 音再生タイマーカウントダウン
        case pause     // 音再生タイマー中断
        case end       // 音再生終了
    } // enumここまで
    // 状態の更新
    func updateState(newState: State) {
        if state == .start && newState == .start {
            // 音再生タイマーをセット
            remainingSeconds = selectedMinutes * 60
        }
        state = newState
    }
    // 音の設定
    override func setSelectedSoundName(soundName: SoundModel) {
        selectedListeningSoundName = soundName.rawValue
    }
} // SoundSetViewModelここまで
