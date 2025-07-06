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
    init() {
        meditationSoundName = Self.loadSound(forKey: UserDefaultsKey.meditationSoundName)
        listeningSoundName = Self.loadSound(forKey: UserDefaultsKey.listeningSoundName)
    }
/// 曲名を引っ張るメソッド
    private static func loadSound(forKey key: String) -> SoundModel {
        // まず、String型で曲名を引っ張る
        if let raw = UserDefaults.standard.string(forKey: key),
           // 次に、enum型にする
           let model = SoundModel(rawValue: raw) {
            return model
        } // if let
        // rawとmodelが存在しなければ、デフォルトでeuropa1を引っ張る
        return .europa1
    } // func loadSound
    /// 音の設定 MeditatingSetViewModelおよびListeningSetViewModelでoverride
    func setSelectedSoundName(soundName: SoundModel) {
    }
    /// 設定値の再取得 MeditatingSetViewModelおよびListeningSetViewModelでoverride
    func setSoundModel() {
    }
} // SetViewModelここまで
