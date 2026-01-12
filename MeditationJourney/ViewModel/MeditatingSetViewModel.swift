//
//  MeditatingSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/12/25.
//

import CoreData
import SwiftUI
import AVFoundation
import MusicKit

class MeditatingSetViewModel: SetViewModel {
    // 瞑想画面での状態　初期値はend
    @Published private(set) var timerState: TimerState = .end
    /// 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published private(set) var remainingSeconds: Int = 0
    /// タイマー
    private var timer: Timer?
    /// タイマーの終了時刻を管理する変数
    private var meditationEndTime: Date?
    /// 瞑想開始日時を記録する変数
    private var meditationStartDate: Date?
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        super.init()
    }
    // タイマーの初期値(瞑想前タイマー5秒)をセット
    func setFirstTimer() {
        remainingSeconds = 5
    }
    // 状態の更新
    func updateTimerState(to: TimerState) {
        // すでにプレスタート状態のときに、スタート状態になった場合
        if timerState == .preStart && to == .start {
            // 瞑想タイマーをセット
            remainingSeconds = meditationMinutes * 60
            // 瞑想開始時刻を記録
            meditationStartDate = Date()
        }
        timerState = to
    }
    // 瞑想前タイマー
    func startPreparationTimer() {
        stopTimer()
        // 終了時刻は、残り時間+1秒を考慮
        meditationEndTime = Date().addingTimeInterval(TimeInterval(remainingSeconds + 1))
        // タイマー起動
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // preStartのとき
            if timerState == .preStart {
                // endTimeが存在するとき
                if let endTime = self.meditationEndTime {
                    // 現在時刻と終了時刻の差を評価し、0以上の値を返す
                    let remainingTimeInterval = max(0, endTime.timeIntervalSince(Date()))
                    // Int型に変換してremainingSecondsに格納
                    remainingSeconds = Int(remainingTimeInterval)
                    // remainingSecondsが0以下のとき
                    if remainingSeconds <= 0 {
                        updateTimerState(to: .start)
                        stopTimer()
                    }
                }  // if let endTime ここまで
            }  // if state == .preStartここまで
        }  // timerHandlerここまで
    }  // funcここまで
    // 瞑想中タイマー
    func startMeditationTimer() {
        // 多重でタイマーを開始しないようにタイマー停止をする
        stopTimer()
        // remainingSecondsが0より大きいとき
        guard remainingSeconds > 0 else {
            return
        }
        // 終了時刻は、残り時間+1秒を考慮
        meditationEndTime = Date().addingTimeInterval(TimeInterval(remainingSeconds + 1))
        // タイマー起動
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // 瞑想中なら
            if timerState == .start {
                // endTimeが存在するとき
                if let endTime = self.meditationEndTime {
                    // 現在時刻と終了時刻の差を評価し、0以上の値を返す
                    let remainingTimeInterval = max(0, endTime.timeIntervalSince(Date()))
                    // Int型に変換してremainingSecondsに格納
                    remainingSeconds = Int(remainingTimeInterval)
                    // remainingSecondsが0以下のとき
                    if remainingSeconds <= 0 {
                        // end
                        timerState = .end
                        // 音の停止
                        updatePlaybackState(to: SetViewModel.PlaybackState.stopped)
                        // タイマー停止
                        stopTimer()
                    } // if remainingSeconds <= 0
                }  // if let endTime
            }  // if state == .startここまで
        }  // timerHandlerここまで
    }  // startMeditationTimer
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
        remainingTime = TimeInterval(meditationMinutes * 60)
        // previewURLとfadeOutEndTimeが存在しなかったら
        guard let previewURL, let fadeOutEndTime else {
            // 処理終了
            return
        }  // guard let
        // 終了時刻は、残り時間を考慮
        endTime = Date().addingTimeInterval(remainingTime)
        // playerがnilのとき（初めての再生のとき）
        if audioPlayer == nil {
            audioPlayer = AVPlayer(url: previewURL)
            // ボリュームを0に設定
            audioPlayer?.volume = 0.0
            // 再生する
            audioPlayer?.play()
            // フェードイン
            fadeIn(player: audioPlayer!, duration: 5)
        }
        // 再生する
        audioPlayer?.play()
        // 多重にfadeOutEndTimeが実行されないようにする
        stopTimer(timer: &fadeOutEndTimer)
        // フェードアウトする時間を管理するタイマー
        fadeOutEndTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            // weak selfをアンラップ
            guard let self = self else { return }
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
            if remainingTime >= 10 {
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
            } else if remainingTime >= 1 && remainingTime < 10 {
                return
            }  // if meditationMinutes...
            // 終了時刻が到来済の場合
        } else if Date() >= endTime {
            if remainingTime < 1 {
                // 状態をstoppedにする
                updatePlaybackState(to: .stopped)
            }
        }
    }  // func fadeOutComplete
    /// タイマー停止・無効
    func stopTimer() {
        // タイマー停止
        timer?.invalidate()
        // タイマー無効
        timer = nil
    }
#if DEBUG
    /// デバッグ用：画面タップで終了
    func forceEndForDebug() {
        // 瞑想中の場合に実行
        if timerState == .start {
            // end状態にする
            timerState = .end
        }
    }
#endif
    /// 時間と音の保存
    override func saveSoundAndMinutes(soundName: SoundModel) {
        meditationSoundName = soundName
        saveMeditationSound()
        saveMeditationMinutes()
    }
    // MARK: - Data Management Methods
    /// 瞑想記録をCoreDataに保存するメソッド
    func saveMeditationRecord() {
        // MeditationInfoエンティティを新規作成
        let newMeditationInfo = MeditationInfo(context: context)
        // 瞑想開始日時を設定（開始日時がない場合は現在の日時を使用）
        newMeditationInfo.date = meditationStartDate ?? Date()
        // 設定された瞑想時間（分）を設定
        newMeditationInfo.meditationTime = Int32(meditationMinutes)
        // 選択された音の名前を設定
        newMeditationInfo.worldSounds = meditationSoundName.rawValue
        // 保存処理
        do {
            try context.save()
        } catch {
            print("瞑想記録の保存に失敗: \(error)")
        }
    }
    deinit {
        stopTimer()
    }
}  // MeditatingSetViewModel
extension MeditatingSetViewModel {
    /// 瞑想タイマー状態の管理
    enum TimerState {
        case preStart  // 瞑想前タイマーカウントダウン
        case prePause  // 瞑想前タイマー中断
        case start  // 瞑想タイマーカウントダウン
        case pause  // 瞑想タイマー中断
        case end  // 瞑想終了
    }  // enum Stateここまで
}
