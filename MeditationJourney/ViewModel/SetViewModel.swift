//
//  SoundSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//<iframe allow="autoplay *; encrypted-media *;" frameborder="0" height="150" style="width:100%;max-width:660px;overflow:hidden;background:transparent;" sandbox="allow-forms allow-popups allow-same-origin allow-scripts allow-storage-access-by-user-activation allow-top-navigation-by-user-activation" src="https://embed.music.apple.com/jp/album/%E9%8A%80%E6%B2%B3%E9%89%84%E9%81%93999-%E3%82%B7%E3%83%B3-%E3%83%9F%E3%83%83%E3%82%AF%E3%82%B9/1576665425?i=1576665786"></iframe>

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
    /// 表示秒数(タイマーの時間)
    @Published private var remainingTime: TimeInterval = 0
    /// タイマーの終了時刻を管理する変数
    private var endTime: Date?
    /// タイマー
    private var timer: Timer?
    /// fadeInを管理
    private var isFadeIn: Bool {
        // stopTimer()でタイマーが停止したらfadeInTimerがnilになる
        return fadeInTimer?.isValid ?? false
    }
    /// fadeInのタイマー
    var fadeInTimer: Timer?
    /// fadeOutを管理
    private var isFadeOut: Bool {
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
    let trackID: String = "1576665786"
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
            // fadeOutの終了時刻は、fadeOutTimeを考慮
            fadeOutEndTime = Date().addingTimeInterval(fadeOutTime)
            playBack()
        case .stopped:
            // 曲を停止
            audioPlayer?.pause()
            // 30秒を入れ直す
            fadeOutTime = 30.0
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
    func playBack() {
        // previewURLとfadeOutEndTimeが存在しなかったら
        guard let previewURL, let fadeOutEndTime else {
            // 処理終了
            return
        }  // guard let
        // playerがnilのとき（初めての再生のとき）
        if audioPlayer == nil {
            // playerにpreviewUrlを代入する
            audioPlayer = AVPlayer(url: previewURL)
            // ボリュームを0に設定
            audioPlayer?.volume = 0.0
            // 再生する
            audioPlayer?.play()
            // フェードイン
            fadeIn(player: audioPlayer!, duration: 5)
        } else {
            // 再生する
            audioPlayer?.play()
        }  // if player
        // 多重にfadeOutEndTimeが実行されないようにする
        stopTimer(timer: &fadeOutEndTimer)
        // フェードアウトする時間を管理するタイマー
        fadeOutEndTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            // 現在時刻
            let now = Date()
            // fadeOutTimeはfadeOutEndTimeに向かって0.1秒スライスする　0と比較し、大きい値を格納
            self.fadeOutTime = max(0, fadeOutEndTime.timeIntervalSince(now))
            // fadeOutTimeの5秒前になったら
            if self.fadeOutTime >= 5 && self.fadeOutTime < 5.1 {
                // 5秒かけてフェードアウト
                self.fadeOut(player: self.audioPlayer!, duration: 5.0) {
                    self.fadeOutComplete()
                }
            } else if self.fadeOutTime > 0 && self.fadeOutTime < 5 {
                // 残り時間をかけてフェードアウト
                self.fadeOut(player: self.audioPlayer!, duration: self.fadeOutTime) {
                    self.fadeOutComplete()
                }
            } else if self.fadeOutTime == 0 {
                // fadeOutTimeが0のとき
                // 処理なし
                return
            }  // if fadeOutTime...
        }  // fadeOutEndTimer
    }  // func playBack()
    // 自然に聞こえるフェードイン
    func fadeIn(player: AVPlayer, duration: TimeInterval) {
        // もしisFadeInとisFadeOutがtrueまたはmeditationMinutesが10秒以下またはlisteningMinutesが10秒以下なら
        if isFadeIn || isFadeOut || meditationMinutes * 60 <= 10 || listeningMinutes * 60 <= 10 {
            return
        }  // if isFadeIn
        // 100ミリ秒ごとに音量を変更
        let interval: TimeInterval = 0.1
        // 合計ステップ（フェードインをする時間が5なら、intervalが0.1なので段階は50）
        let totalSteps = Int(duration / interval)
        // 現在のステップ　初期は0
        var currentStep = 0
        // フェードインのタイマー
        fadeInTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            // 現在の段階が合計段階よりも小さいとき
            if currentStep < totalSteps {
                // 音量の変更を指数関数的に調整
                let normalizedTime = Double(currentStep) / Double(totalSteps)
                // 2乗することで、初期はゆっくり、後半は急激に上昇
                player.volume = Float(pow(normalizedTime, 2))
                // 現在のステップ　初期は0
                currentStep += 1
            } else {
                // 最大音量に設定
                player.volume = 1.0
                // fadeInTimerを無効、nilに
                self.stopTimer(timer: &self.fadeInTimer)
            }  // if currentStep < totalSteps
        }  // fadeInTimer
    }  // func fadeIn
    // 自然に聞こえるフェードアウト
    func fadeOut(player: AVPlayer, duration: TimeInterval, completion: @escaping () -> Void) {
        // フェードアウトしているとき
        if isFadeOut == true {
            // 何も処理しない
            return
        }  // if isFadeOut...
        // フェードアウトは0.1刻み
        let interval: TimeInterval = 0.1
        // 合計ステップ（フェードアウトをする時間が5なら、intervalが0.1なので段階は50）
        let totalSteps = Int(duration / interval)
        // 現在のステップ　初期は0
        var currentStep = 0
        // 現在の音量を開始音量とする
        let startVolume = player.volume
        // フェードアウトのタイマー　インターバルは0.1、繰り返す
        fadeOutTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            // 現在の段階が合計段階よりも小さいとき
            if currentStep < totalSteps {
                // 音量の変更を指数関数的に調整
                let normalizedTime = Double(currentStep) / Double(totalSteps)
                // 音量が徐々に減少
                player.volume = Float(startVolume * pow(Float(1.0 - normalizedTime), 2))
                // 現在の段階に1を足す
                currentStep += 1
            } else {
                // 音量をゼロに設定
                player.volume = 0.0
                // プレイヤーを止める
                player.pause()
                // プレイヤーをnilに
                self.audioPlayer = nil
                // fadeOutTimerを無効、nilに
                self.stopTimer(timer: &self.fadeOutTimer)
                // フェードアウトが終わったらクロージャーを呼び出す
                // 同期関数内のためTask使用、メインスレッドに乗り換えたためクロージャー呼び出し
                Task { @MainActor in
                    completion()
                }  // Task
            }  // if currentStep
        }  // Timer
    }  // func fadeOut
    // 再生完了後の処理
    func fadeOutComplete() {
        // endTimeが存在しない場合は何もしない
        guard let endTime else {
            return
        }
        // 終了時間が未到来の場合
        if Date() < endTime {
            // meditationMinutesまたはlisteningMinutesが10以上の場合
            if meditationMinutes >= 10 || listeningMinutes >= 10 {
                print("再度再生します。")
                // fadeOutEndTimerを無効、nilにする
                stopTimer(timer: &fadeOutEndTimer)
                // fadeOutTimeに30を格納（30秒後をフェードアウト終了時間とするため）
                fadeOutTime = 30
                // fadeOutの終了時刻は、1行上で30を入れたfadeOutTimeを考慮
                fadeOutEndTime = Date().addingTimeInterval(fadeOutTime)
                // 再生
                playBack()
                // meditationMinutesが1以上10未満の場合
            } else if meditationMinutes >= 1 && meditationMinutes < 10 || listeningMinutes >= 1 && listeningMinutes < 10 {
                return
            }  // if meditationMinutes...
            // 終了時刻が到来済の場合
        } else if Date() >= endTime {
            if meditationMinutes < 1 || listeningMinutes < 1 {
                // 状態をstoppedにする
                updatePlaybackState(to: .stopped)
            }
        }
    }  // func fadeOutComplete
    // func stopTimer
    func stopTimer(timer: inout Timer?) {
        // タイマーを停止する時は、invalidate()してからnilにする処理をセットにした関数を作成
        // タイマーを無効化
        timer?.invalidate()
        // タイマーをnil
        timer = nil
    }  // stopTimer()
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
