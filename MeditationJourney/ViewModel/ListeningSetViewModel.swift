//
//  ListeningSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/03/06.
//

import SwiftUI
import AVFoundation
import MusicKit

class ListeningSetViewModel: SetViewModel {
    /// 瞑想画面での状態　初期値はidle
    @Published private(set) var timerState: TimerState = .idle
    /// 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published private(set) var remainingSeconds: TimeInterval = 0
    /// 状態の更新
    func updateTimerState(to newState: TimerState) {
        if timerState == .end && newState == .start {
            // listeningMinutesが0でないとき
            if listeningMinutes != 0 {
                // 音再生タイマーをセット
                remainingSeconds = TimeInterval(listeningMinutes * 60)
                // listeningMinutesが0のとき
            } else {
                remainingSeconds = 0
            }
        }
        timerState = newState
    }
    func startPlayAndTimer() {
        // 多重でタイマーを開始しないようにする
        stopTimer(timer: &selectedDurationMinutesTimer)
        // 終了時刻は、残り時間を考慮
        endTime = Date().addingTimeInterval(remainingSeconds)
        // fadeOutの終了時刻は、fadeOutTimeを考慮
        fadeOutEndTime = Date().addingTimeInterval(fadeOutTime)
        print("現在時刻は\(Date())")
        print("終了時刻を計算すると\(String(describing: endTime))")
        print("fadeOutEndTimeを計算すると\(String(describing: fadeOutEndTime))")
        // 再生を開始
        resumePlayback()
        // タイマーを開始
        startListeningTimer()
        print("タイマーは\(endTime!)で終わり")
    }
    // 音をきくタイマー
    func startListeningTimer() {
        // 多重でタイマーを開始しないようにタイマー停止をする
        stopTimer(timer: &selectedDurationMinutesTimer)
        // remainingSecondsが0より大きいとき
        guard remainingSeconds > 0 else {
            return
        }
        // 終了時刻は、残り時間を考慮
        endTime = Date().addingTimeInterval(remainingSeconds)
        // タイマー起動
        selectedDurationMinutesTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // 瞑想中なら
            if timerState == .start {
                // endTimeが存在するとき
                if let endTime = self.endTime {
                    // 現在時刻と終了時刻の差を評価し、0以上の値を返す
                    let remainingTimeInterval = max(0, endTime.timeIntervalSince(Date()))
                    // 小数点を切上げ（小数点第1位が1~9のとき、切上げした正数を表示するため）
                    remainingSeconds = ceil(remainingTimeInterval)
                    // remainingSecondsが0以下のとき
                    if remainingSeconds <= 0 {
                        // end
                        updateTimerState(to: .end)
                        updatePlaybackState(to: SetViewModel.PlaybackState.stop)
                        // タイマー停止
                        stopTimer(timer: &selectedDurationMinutesTimer)
                    } // if remainingSeconds <= 0
                }  // if let endTime
            }  // if state == .startここまで
        }  // selectedDurationTimerここまで
    }  // startListeningTimer
    /// 時間と音の保存
    override func saveSoundAndMinutes(soundName: SoundModel) {
        listeningSoundName = soundName
        saveListeningSound()
        saveListeningMinutes()
    }
    /// プレビューURLを取得するメソッド（成功した場合trueを返す）
    override func fetchPreviewURL(for trackID: String) async -> Bool {
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
    override func resumePlayback() {
        configureAudioSession()
        // previewURLとfadeOutEndTimeが存在しなかったら
        guard let previewURL, let fadeOutEndTime else {
            // 処理終了
            return
        }  // guard let
        // playerがnilのとき（初めての再生のとき）
        if audioPlayer == nil {
            audioPlayer = AVPlayer(url: previewURL)
            // ボリュームを0に設定
            audioPlayer?.volume = 0.0
            // 再生する
            audioPlayer?.play()
            // フェードイン
            guard let player = audioPlayer else {
                return
            }
            fadeIn(player: player, duration: 5)
        }
        // 再生する
        audioPlayer?.play()
        // 多重にfadeOutEndTimeが実行されないようにする
        stopTimer(timer: &fadeOutEndTimer)
        // フェードアウトする時間を管理するタイマー
        fadeOutEndTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            // weak selfをアンラップ
            guard let self = self else { return }
            guard let player = self.audioPlayer else { return }
            // 現在時刻
            let now = Date()
            // fadeOutTimeはfadeOutEndTimeに向かって0.1秒スライスする　0と比較し、大きい値を格納
            self.fadeOutTime = max(0, fadeOutEndTime.timeIntervalSince(now))
            // fadeOutTimeの5秒前になったら
            if self.fadeOutTime >= 5 && self.fadeOutTime < 5.1 {
                // 5秒かけてフェードアウト
                self.fadeOut(player: player, duration: 5.0) {
                    self.fadeOutComplete()
                }
            } else if self.fadeOutTime > 0 && self.fadeOutTime < 5 {
                // 残り時間をかけてフェードアウト
                self.fadeOut(player: player, duration: self.fadeOutTime) {
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
    override func fadeIn(player: AVPlayer, duration: TimeInterval) {
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
        fadeInTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            // weak selfをアンラップ
            guard let self = self else { return }
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
    override func fadeOut(player: AVPlayer, duration: TimeInterval, completion: @escaping () -> Void) {
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
        fadeOutTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            // weak selfをアンラップ
            guard let self = self else { return }
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
    override func fadeOutComplete() {
        // endTimeが存在しない場合は何もしない
        guard let endTime else {
            return
        }
        // 終了時間が未到来の場合
        if Date() < endTime {
            // remainingTimeが10以上の場合
            if remainingSeconds >= 10 {
                print("再度再生します。")
                // fadeOutEndTimerを無効、nilにする
                stopTimer(timer: &fadeOutEndTimer)
                // fadeOutTimeに30を格納（30秒後をフェードアウト終了時間とするため）
                fadeOutTime = 30
                // fadeOutの終了時刻は、1行上で30を入れたfadeOutTimeを考慮
                fadeOutEndTime = Date().addingTimeInterval(fadeOutTime)
                // 再生
                resumePlayback()
                // remainingTimeが1以上10未満の場合
            } else if remainingSeconds >= 1 && remainingSeconds < 10 {
                return
            }  // if meditationMinutes...
            // 終了時刻が到来済の場合
        } else if Date() >= endTime {
            if remainingSeconds < 1 {
                // 状態をstoppedにする
                updatePlaybackState(to: .stop)
            }
        }
    }  // func fadeOutComplete
    /// 再生状態を更新するメソッド
    override func updatePlaybackState(to newState: PlaybackState) {
        // newStateが以下の状態となる場合
        switch newState {
            // 再生状態になったら
        case .playing:
            // startPlayAndTimerを実行
            startPlayAndTimer()
        case .stop:
            // 曲を停止
            audioPlayer?.pause()
            // 30秒を入れ直す
            fadeOutTime = 30.0
            // playerをnilに
            audioPlayer = nil
            // selectedDurationMinutesTimerを無効、nil
            stopTimer(timer: &selectedDurationMinutesTimer)
            // fadeOutEndTimerを無効、nilにする
            stopTimer(timer: &fadeOutEndTimer)
        case .pause:
            // 曲を一時停止
            audioPlayer?.pause()
            // selectedDurationMinutesTimerを無効、nil
            stopTimer(timer: &selectedDurationMinutesTimer)
            // fadeOutEndTimerを無効、nilにする
            stopTimer(timer: &fadeOutEndTimer)
            // fadeOutTimerを無効、nilにする
            stopTimer(timer: &fadeOutTimer)
        }  // switch newState
        playbackState = newState
    }
    /// タイマー停止・無効
    override func stopTimer(timer: inout Timer?) {
        // タイマー停止
        timer?.invalidate()
        // タイマー無効
        timer = nil
    }
    deinit {
        stopTimer(timer: &selectedDurationMinutesTimer)
    }
    // 他アプリの音を止めこのアプリの音を優先する(電話・緊急アラートは自動的に最優先)メソッド
    override func configureAudioSession() {
        // シングルトンインスタンスを取得
        let session = AVAudioSession.sharedInstance()
        do {
            // setCategoryでアプリの音の用途を宣言
            // .soloAmbientは他アプリの音を止めてこのアプリの音を優先
            // mode: .default = デフォルトモード
            try session.setCategory(.soloAmbient, mode: .default)
            // 成功した場合は音声セッションをアクティブにする（true）
            try session.setActive(true)
        } catch {
            // エラーが発生した場合は、エラーを表示
            print("AVAudioSession設定エラー: \(error)")
        }
    } // configureAudioSession()
}  // ListeningSetViewModelここまで
extension ListeningSetViewModel {
    enum TimerState {
        case idle // 開始前の待機状態
        case start  // 音再生タイマーカウントダウン
        case pause  // 音再生タイマー中断
        case end  // 音再生終了
    }  // enumここまで
}  // extension ListeningSetViewModelここまで
