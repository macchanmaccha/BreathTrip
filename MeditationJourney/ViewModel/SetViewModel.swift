//
//  SoundSetViewModel.swift
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
    /// 曲のID
    let trackID: String = "1613642543"
    /// 再生状態　初期は.stopped
    private var playbackState: PlaybackState = .stopped
    /// プレビューURL
    private var previewURL: URL?
    /// プレイヤー
    private var audioPlayer: AVPlayer?
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
        return UserDefaults.standard.integer(forKey: key)
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
    /// 時間と音の保存 MeditatingSetViewModelおよびListeningSetViewModelでoverride
    func saveSoundAndMinutes(soundName: SoundModel) {
    }
    // MARK: - Apple Music API Methods
    /// 再生状態を更新するメソッド
    func updatePlaybackState(to: PlaybackState) {
        // toが以下の状態となる場合
        switch to {
        // 再生状態になったら
        case .playing:
            playBack()
        case .stopped:
            // 曲を停止
            audioPlayer?.pause()
            // playerをnilに
            audioPlayer = nil
        case .paused:
            // 曲を一時停止
            audioPlayer?.pause()
        }  // switch newState
        playbackState = to
    }
    /// プレビューURLを取得するメソッド（成功した場合trueを返す）
    func fetchPreviewURL(for trackID: String) async -> Bool {
        // エラーを出すメソッドを安全に返す(request)
        do {
            // Apple Musicの認証ステータス
            let musicAuthorizationStatus = await MusicAuthorization.request()
            // 認証されなかったら
            guard musicAuthorizationStatus == .authorized else {
                // アラート表示（メインスレッドで実行）
                await MainActor.run {
                    self.isShowAlert = true
                }
                // 処理終了　失敗を返す
                return false
            }  // guard musicAuthorizationStatus
            // 楽曲IDを指定してリクエストを作成
            let request = MusicCatalogResourceRequest<Song>(
                matching: \.id, equalTo: MusicItemID(trackID))
            // レスポンスを取得
            let response = try await request.response()
            // 曲とプレビューURLが存在する場合
            if let song = response.items.first,
                let previewURL = song.previewAssets?.first?.url {
                // previewURLに代入
                self.previewURL = previewURL
                // 成功を返す
                return true
            }  // if let
            // プレビューURLが取得できなかった場合
            return false
            // エラーの場合
        } catch {
            return false
        }  // do catch
    }  // fetchPreviewURL
    /// 曲を再生するメソッド
    private func playBack() {
        // previewURLが存在しなかったら
        guard let previewURL else {
            // 処理終了
            return
        }  // guard let
        // playerがnilのとき（初めての再生のとき）
        if audioPlayer == nil {
            // playerにpreviewUrlを代入する
            audioPlayer = AVPlayer(url: previewURL)
            // 再生する
            audioPlayer?.play()
        } else {
            // 再生する
            audioPlayer?.play()
        }  // if player
    }  // func playBack()
}  // SetViewModelここまで
extension SetViewModel {
    // 再生状態を管理する列挙体
    enum PlaybackState {
        // 再生中
        case playing
        // 停止
        case stopped
        // 一時停止
        case paused
    } // enum PlaybackStateここまで
}
