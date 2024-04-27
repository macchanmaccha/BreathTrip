//
//  SoundSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import Foundation

class SetViewModel: ObservableObject {
    /// 瞑想の音を表示する変数
    @Published var meditationSoundName: SoundModel {
        didSet {UserDefaults.standard.set(meditationSoundName.rawValue, forKey: UserDefaultsKey.meditationSoundName)}
    }
    /// 再生する音を表示する変数
    @Published var listeningSoundName: SoundModel {
        didSet {UserDefaults.standard.set(listeningSoundName.rawValue, forKey: UserDefaultsKey.listeningSoundName)}
    }
    /// UserDefaultsの初期化
    init () {
        meditationSoundName = SoundModel(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.meditationSoundName) ?? SoundModel.europe1.rawValue) ?? SoundModel.europe1
        listeningSoundName = SoundModel(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.listeningSoundName) ?? SoundModel.europe1.rawValue) ?? SoundModel.europe1
    }
    /// 音の設定 MeditatingSetViewModelおよびListeningSetViewModelでoverride
    func setSelectedSoundName(soundName: SoundModel) {
    }
    /// 設定値の再取得 MeditatingSetViewModelおよびListeningSetViewModelでoverride
    func setSoundModel() {
    }
} // SetViewModelここまで
