//
//  SetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import Foundation
import AVFoundation
import MusicKit

class SetViewModel: ObservableObject {
    /// 瞑想の音を表示する変数
    @Published var meditationSoundName: SoundModel
    /// 再生する音を表示する変数
    @Published var listeningSoundName: SoundModel
    /// 瞑想の分数
    @Published var meditationMinutes: Int
    /// 音を聞く時のみの分数
    @Published var listeningMinutes: Int
    /// 設定画面へ誘導するアラート
    @Published var isShowAlert = false
    /// タイマーの終了時刻を管理する変数
    var endTime: Date?
    /// fadeInを管理
    var isFadeIn: Bool {
        // stopTimer()でタイマーが停止したらfadeInTimerがnilになる
        return fadeInTimer?.isValid ?? false
    }
    /// ユーザーが選択するタイマー
    var selectedDurationMinutesTimer: Timer?
    /// fadeInのタイマー
    var fadeInTimer: Timer?
    /// fadeOutを管理
    var isFadeOut: Bool {
        // stopTimer()でタイマーが停止したらfadeOutTimerがnilになる
        return fadeOutTimer?.isValid ?? false
    }
    /// fadeOutのタイマー
    var fadeOutTimer: Timer?
    /// fadeOutの終了時間を管理する変数
    var fadeOutEndTime: Date?
    /// fadeOutの秒数を管理する変数（初期値は30.0）
    var fadeOutTime: TimeInterval = 30.0
    /// fadeOutを終了するタイマー
    var fadeOutEndTimer: Timer?
    /// 曲のID
    var trackID: String {
        meditationSoundName.fileName
    }
    /// 再生状態　初期は.stop
    var playbackState: PlaybackState = .stop
    /// プレビューURL
    var previewURL: URL?
    /// プレイヤー
    var audioPlayer: AVPlayer?
    /// UserDefaultsの初期化
    init() {
        meditationSoundName = Self.loadSound(withKey: UserDefaultsKey.meditationSoundName)
        listeningSoundName = Self.loadSound(withKey: UserDefaultsKey.listeningSoundName)
        meditationMinutes = Self.loadMinutes(withKey: UserDefaultsKey.meditationMinutes)
        listeningMinutes = Self.loadMinutes(withKey: UserDefaultsKey.listeningMinutes)
    }
    /// 曲名を引っ張るメソッド
    private static func loadSound(withKey key: String) -> SoundModel {
        // まず、String型で曲名を引っ張る
        if let raw = UserDefaults.standard.string(forKey: key),
           // 次に、enum型にする
           let model = SoundModel(rawValue: raw) {
            return model
        }  // if let
        // rawとmodelが存在しなければ、デフォルトでeuropa1を引っ張る
        return .europa1
    }  // func loadSound
    /// 分数を引っ張るメソッド
    private static func loadMinutes(withKey key: String) -> Int {
        UserDefaults.standard.integer(forKey: key)
    }
    func saveMeditationSound() {
        UserDefaults.standard.set(
            meditationSoundName.rawValue, forKey: UserDefaultsKey.meditationSoundName)
    }
    func saveListeningSound() {
        UserDefaults.standard.set(
            listeningSoundName.rawValue, forKey: UserDefaultsKey.listeningSoundName)
    }
    func saveMeditationMinutes() {
        UserDefaults.standard.set(meditationMinutes, forKey: UserDefaultsKey.meditationMinutes)
    }
    func saveListeningMinutes() {
        UserDefaults.standard.set(listeningMinutes, forKey: UserDefaultsKey.listeningMinutes)
    }
    /// サブクラスでオーバーライドして実装する
    /// - Parameter soundName: 保存する音のモデル
    func saveSoundAndMinutes(soundName: SoundModel) {
        // サブクラスでオーバーライド
    }
    // 他アプリとの音の競合対策
    func configureAudioSession() {
    }
    // Apple Music API Methods
    /// 再生状態を更新するメソッド
    func updatePlaybackState(to newState: PlaybackState) {
    }
    /// プレビューURLを取得するメソッド（成功した場合trueを返す）
    func fetchPreviewURL(for trackID: String) async -> Bool {
        return false
    }  // fetchPreviewURL
    /// 曲を再生するメソッド
    func resumePlayback() {
    }  // func resumePlayBack()
    // 自然に聞こえるフェードイン
    func fadeIn(player: AVPlayer, duration: TimeInterval) {
    }  // func fadeIn
    // 自然に聞こえるフェードアウト
    func fadeOut(player: AVPlayer, duration: TimeInterval, completion: @escaping () -> Void) {
    }  // func fadeOut
    // 再生完了後の処理
    func fadeOutComplete() {
    }  // func fadeOutComplete
    // func stopTimer
    func stopTimer(timer: inout Timer?) {
        // タイマーを停止する時は、invalidate()してからnilにする処理をセットにした関数を作成
        // タイマーを無効化
        timer?.invalidate()
        // タイマーをnil
        timer = nil
    }  // stopTimer()
    // 終了時
    deinit {
        // プレイヤー停止
        audioPlayer?.pause()
        // プレイヤーをnil
        audioPlayer = nil
    }
}  // SetViewModelここまで
extension SetViewModel {
    // 再生状態を管理する列挙体
    enum PlaybackState {
        // 再生中
        case playing
        // 停止
        case stop
        // 一時停止
        case pause
    } // enum PlaybackStateここまで
}
