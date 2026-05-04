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
    @Published var isShowStopAlert: Bool = false
    @Published var isShowEndAlert: Bool = false
    /// プレタイマー表示管理
    var shouldShowPreTimer: Bool {
        if timerState == .preStart || timerState == .prePause {
            return true
        } else if timerState == .suspended,
                  let state = stateBeforeLeaving,
                  state == .preStart || state == .prePause {
            return true
        } else {
            return false
        }
    }
    /// 瞑想中タイマーを表示する条件を管理する計算型プロパティ
    var shouldShowTimer: Bool {
        // startのときまたは、pauseのときまたは、suspendedかつstateBeforeLeavingがstartのとき
        timerState == .start
        || timerState == .pause
        || (timerState == .suspended && stateBeforeLeaving == .start)
    }
    /// 中断ボタン管理
    var shouldShowInterruptButton: Bool {
        timerState != .end && !(timerState == .suspended && stateBeforeLeaving == .end)
    }
    /// 瞑想前のタイマー
    var preparationTimer: Timer?
    /// 曲のID
    var trackID: String {
        meditationSoundName.fileName
    }
    /// 瞑想開始日時を記録する変数
    private var meditationStartDate: Date?
    /// 音声ガイド（ローカル音源再生）
    private var audioGuidePlayer: AVAudioPlayer?
    /// 中盤ガイドを既に再生したしきい値（秒）のキー
    private var spokenMidCueKeys: Set<String> = []
    /// 姿勢ガイドをこのセッションで再生済みか
    private var hasSpokenPostureThisSession = false
    /// 締めのガイドを再生済みか
    private var hasSpokenClosingPhrase = false
    /// 画面を離れる前の状態（復帰時に再開するため）
    private(set) var stateBeforeLeaving: TimerState?
    /// 音声ガイドのON/OFFを管理 初期値はfalse
    private var isAudioGuideEnabled: Bool = false
    /// 瞑想画面での状態　初期値はidle
    @Published private(set) var timerState: TimerState = .idle
    /// 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published private(set) var remainingSeconds: TimeInterval = 0
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        super.init()
    }
    // タイマーの初期値(瞑想前タイマー5秒)をセット
    func setFirstTimer() {
        remainingSeconds = 5
    }
    /// 画面起動時の初期化処理（preStart状態の設定と瞑想前タイマーのセット）
    func onViewAppear() {
        // 新しいセッション開始時に、音声ガイドの再生履歴を初期化する
        resetAudioGuideSessionState()
        updateMeditationTimerState(to: .preStart)
        setFirstTimer()
        // 瞑想開始前に姿勢ガイド（001）を一度だけ流す
        speakPostureGuideIfNeeded()
    }
    /// 準備前タイマーから瞑想タイマーへの状態の更新
    func updateMeditationTimerState(to newState: TimerState) {
        if timerState == .preStart && newState == .start {
            // 瞑想タイマーをセット
            remainingSeconds = TimeInterval(meditationMinutes * 60)
            // 瞑想開始時刻を記録
            meditationStartDate = Date()
        }
        timerState = newState
    }
    /// 中断ボタンタップ時の処理
    func onInterruptButtonTapped() {
        switch timerState {
             // preStartのとき
        case .preStart:
            // prePauseにする
            updateMeditationTimerState(to: .prePause)
            // startのとき
        case .start:
            // pauseにする
            updateMeditationTimerState(to: .pause)
            // 離脱状態の場合
        case .suspended:
            // 離脱前がpreStartだった時
            if stateBeforeLeaving == .preStart {
                // prePauseにする
                updateMeditationTimerState(to: .prePause)
                // 離脱前がstartだった時
            } else if stateBeforeLeaving == .start {
                // pauseにする
                updateMeditationTimerState(to: .pause)
            }
        default:
            break
        }
    }
    /// 中断アラートのNOボタンタップ時の処理（再開）
    func onInterruptAlertNoTapped() {
        switch timerState {
        case .prePause:
            updateMeditationTimerState(to: .preStart)
        case .pause:
            updateMeditationTimerState(to: .start)
        case .suspended:
            if stateBeforeLeaving == .preStart || stateBeforeLeaving == .prePause {
                updateMeditationTimerState(to: .preStart)
            } else if stateBeforeLeaving == .pause || stateBeforeLeaving == .start {
                updateMeditationTimerState(to: .start)
            }
        default:
            break
        }
    }
    /// 中断アラートのYESボタンタップ時の処理（終了）
    func onInterruptAlertYesTapped() {
        stopTimer(timer: &selectedDurationMinutesTimer)
        stopTimer(timer: &preparationTimer)
        // 音の再生を完全に停止
        updatePlaybackState(to: SetViewModel.PlaybackState.stop)
    }
    /// remainingSecondsの変化時の処理（5秒でフェードアウト、0以下で終了）
    func onRemainingSecondsChanged(newValue: TimeInterval) {
        if newValue > 5 && newValue < 5.1 {
            if let player = audioPlayer {
                fadeOut(player: player, duration: 5.0) {
                    self.fadeOutComplete()
                }
            }
        } else if newValue <= 0 {
            updateMeditationTimerState(to: .end)
        }
    }
    // バックグラウンドへの状態の更新
    func updateBackground(to newState: TimerState) {
        if newState == .suspended {
            // prePause,preStart,Pause,Startのいずれかが入る
            stateBeforeLeaving = timerState
        }
        timerState = newState
    }
    // 割り込みの更新（通知を受け取り、種類に応じて適切なメソッドに振り分け）
    func updateInterruption(notification: NotificationCenter.Publisher.Output) {
        // 通知を受け取ったら、userInfoを取得 userInfoは通知の内容を含む辞書
        guard let userInfo = notification.userInfo,
              // 通知の種類を取得
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              // 通知の種類をAVAudioSession.InterruptionTypeに変換
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
        // 通知の種類に応じて処理を分岐
        switch type {
        case .began:
            updateInterruptionBegan()
        default:
            break
        }
    }
    // 音声割り込み開始時の状態更新（着信・緊急アラートなどで音が止まったとき）
    private func updateInterruptionBegan() {
        switch timerState {
        case .preStart:
            updateMeditationTimerState(to: .prePause)
        case .start:
            updateMeditationTimerState(to: .pause)
        default:
            break
        }
    }
    // 瞑想前タイマー
    func startPreparationTimer() {
        stopTimer(timer: &preparationTimer)
        // 終了時刻は、残り時間を考慮
        endTime = Date().addingTimeInterval(remainingSeconds)
        // タイマー起動
        preparationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // preStartのとき
            if timerState == .preStart {
                // endTimeが存在するとき
                if let endTime = self.endTime {
                    // 現在時刻と終了時刻の差を評価し、0以上の値を返す
                    let remainingTimeInterval = max(0, endTime.timeIntervalSince(Date()))
                    // 小数点を切上げ（小数点第1位が1~9のとき、切上げした正数を表示するため）
                    remainingSeconds = ceil(remainingTimeInterval)
                    if remainingSeconds == 0 {
                        updateMeditationTimerState(to: .start)
                        stopTimer(timer: &preparationTimer)
                    }
                }  // if let endTime ここまで
            }  // if state == .preStartここまで
        }  // timerHandlerここまで
    }  // funcここまで
    func startPlayAndTimer() {
        // 多重でタイマーを開始しないようにする
        stopTimer(timer: &selectedDurationMinutesTimer)
        // 終了時刻は、残り時間を考慮
        endTime = Date().addingTimeInterval(remainingSeconds)
        // fadeOutの終了時刻は、fadeOutTimeを考慮
        fadeOutEndTime = Date().addingTimeInterval(fadeOutTime)
        // 再生を開始
        resumePlayback()
        // タイマーを開始
        startMeditationTimer()
    }
    // 瞑想中タイマー
    func startMeditationTimer() {
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
                    // 残り時間に応じて中盤/締めガイドの再生判定を行う
                    evaluateMeditationAudioGuide(remainingSeconds: remainingSeconds)
                    // remainingSecondsが0以下のとき
                    if remainingSeconds <= 0 {
                        // end
                        updateMeditationTimerState(to: .end)
                        // 音の停止
                        updatePlaybackState(to: SetViewModel.PlaybackState.stop)
                        // タイマー停止
                        stopTimer(timer: &selectedDurationMinutesTimer)
                    } // if remainingSeconds <= 0
                }  // if let endTime
            }  // if state == .startここまで
        }  // selectedDurationTimerここまで
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
    /// タイマー停止・無効
    override func stopTimer(timer: inout Timer?) {
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
            updateMeditationTimerState(to: .end)
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
    // タイマーを更新するメソッド
    func updateTimer() {
        switch timerState {
        case .idle:
            // 何もしない
            break
        case .preStart:
            // 瞑想前タイマーの呼出
            startPreparationTimer()
            // スリープを無効
            UIApplication.shared.isIdleTimerDisabled = true
        case .prePause:
            // タイマー停止・無効
            stopTimer(timer: &selectedDurationMinutesTimer)
            stopTimer(timer: &preparationTimer)
            // isShowAlertをtrue
            isShowStopAlert = true
            // スリープを有効
            UIApplication.shared.isIdleTimerDisabled = false
        case .start:
            // 音の再生を開始
            updatePlaybackState(to: SetViewModel.PlaybackState.playing)
            // スリープを無効
            UIApplication.shared.isIdleTimerDisabled = true
        case .pause:
            // タイマー停止・無効
            stopTimer(timer: &selectedDurationMinutesTimer)
            // 音の再生を一時停止
            updatePlaybackState(to: SetViewModel.PlaybackState.pause)
            // isShowAlertをtrue
            isShowStopAlert = true
            // スリープを有効
            UIApplication.shared.isIdleTimerDisabled = false
        case .end:
            // タイマー停止・無効
            stopTimer(timer: &selectedDurationMinutesTimer)
            stopTimer(timer: &preparationTimer)
            // 音の再生を停止
            updatePlaybackState(to: SetViewModel.PlaybackState.stop)
            // 保存メソッドを呼び出し
            saveMeditationRecord()
            // 終了アラート表示
            isShowEndAlert.toggle()
            // スリープを有効
            UIApplication.shared.isIdleTimerDisabled = false
        case .suspended:
            // タイマー停止・無効
            stopTimer(timer: &selectedDurationMinutesTimer)
            stopTimer(timer: &preparationTimer)
            if stateBeforeLeaving == .end {
                // 終了状態で画面離脱した場合：終了アラートを表示し、中断アラートは表示しない
                isShowStopAlert = false
                // isShowEndAlert = true
            } else {
                // 音の再生を一時停止
                updatePlaybackState(to: SetViewModel.PlaybackState.pause)
                // isShowAlertをtrue
                isShowStopAlert = true
            }
            // スリープを有効
            UIApplication.shared.isIdleTimerDisabled = false
        } // switch
    }
    /// 再生状態を更新するメソッド
    override func updatePlaybackState(to newState: PlaybackState) {
        // newStateが以下の状態となる場合
        switch newState {
            // 再生状態になったら
        case .playing:
            // startPlayAndTimerを実行
            startPlayAndTimer()
        case .stop:
            stopAudioGuideSpeech()
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
            stopAudioGuideSpeech()
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
    // MARK: - 音声ガイド
    // 1セッション内での重複再生を防ぐためのフラグを初期化する
    private func resetAudioGuideSessionState() {
        isAudioGuideEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKey.audioGuide)
        spokenMidCueKeys.removeAll()
        hasSpokenPostureThisSession = false
        hasSpokenClosingPhrase = false
    }
    // 姿勢ガイド（001）を1回だけ再生する
    private func speakPostureGuideIfNeeded() {
        // isAudioGuideEnabledがtrueでhasSpokenPostureThisSessionがfalse以外のときは
        guard isAudioGuideEnabled, !hasSpokenPostureThisSession else {
            // なにもしない
            return
        }
        hasSpokenPostureThisSession = true
        playAudioGuide(trackNumber: 1)
    }
    /// 瞑想中の残り時間を監視し、未再生のガイド音源を必要なタイミングで1回だけ再生する。
    /// - 残り5秒以内: 締めガイド（010）
    /// - それ以前: 分数に応じた中盤キューで 002 以降を順番に再生
    private func evaluateMeditationAudioGuide(remainingSeconds: TimeInterval) {
        // ガイドがONかつ瞑想中（start）でない場合は判定しない
        guard isAudioGuideEnabled, timerState == .start else {
            return
        }
        // 終了直前（5秒以内）に締めガイド（010）を1回だけ再生する
        if remainingSeconds <= 5 && remainingSeconds > 0 && !hasSpokenClosingPhrase {
            hasSpokenClosingPhrase = true
            playAudioGuide(trackNumber: 10)
            return
        }
        // 残り5秒以下では、中盤ガイドを鳴らさない
        guard remainingSeconds > 5 else {
            return
        }
        // 分数ごとのしきい値を走査し、条件を満たした中盤ガイドを1回だけ再生する
        for (index, cue) in MeditationAudioGuide.midCueSecondsRemaining(forMinutes: meditationMinutes).enumerated() {
            // しきい値をキー化して多重再生を防止する
            let key = "mid_\(Int(cue))"
            print("残り時間は\(remainingSeconds),\(key)")
            if remainingSeconds <= cue && !spokenMidCueKeys.contains(key) {
                spokenMidCueKeys.insert(key)
                // 中盤ガイドは002以降の連番音源を順番に再生する
                playAudioGuide(trackNumber: index + 2)
                break
            }
        }
    }
    // 指定番号（例: 001, 002...）のローカル音源を再生する
    private func playAudioGuide(trackNumber: Int) {
        guard isAudioGuideEnabled else {
            return
        }
        guard let url = audioGuideURL(trackNumber: trackNumber) else {
            print("音声ガイドファイルが見つかりません: \(trackNumber)")
            return
        }
        do {
            audioGuidePlayer?.stop()
            audioGuidePlayer = try AVAudioPlayer(contentsOf: url)
            audioGuidePlayer?.prepareToPlay()
            audioGuidePlayer?.play()
        } catch {
            print("音声ガイド再生エラー: \(error)")
        }
    }
    /// ファイル名の先頭プレフィックス（001_ など）で音源URLを検索する
    private func audioGuideURL(trackNumber: Int) -> URL? {
        let prefix = String(format: "%03d_", trackNumber)
        let extensions = ["wav", "m4a", "caf", "mp3"]
        for ext in extensions {
            let urls = Bundle.main.urls(forResourcesWithExtension: ext, subdirectory: nil) ?? []
            if let matchedURL = urls.first(where: { $0.lastPathComponent.hasPrefix(prefix) }) {
                return matchedURL
            }
        }
        return nil
    }
    // ガイド音声の再生を停止し、プレイヤーを解放する
    private func stopAudioGuideSpeech() {
        audioGuidePlayer?.stop()
        audioGuidePlayer = nil
    }
    deinit {
        stopAudioGuideSpeech()
        stopTimer(timer: &selectedDurationMinutesTimer)
        stopTimer(timer: &preparationTimer)
        stopTimer(timer: &fadeInTimer)
        stopTimer(timer: &fadeOutTimer)
        stopTimer(timer: &fadeOutEndTimer)
    }
    // 他アプリの音を止めこのアプリの音を優先する(電話・緊急アラートは自動的に最優先)メソッド
    override func configureAudioSession() {
        // シングルトンインスタンスを取得
        let session = AVAudioSession.sharedInstance()
        do {
            // setCategoryでアプリの音の用途を宣言
            // .soloAmbient = ソロアンビエントモード。他アプリの音を止めて、このアプリの音を優先する
            // mode: .default = デフォルトモード
            try session.setCategory(.soloAmbient, mode: .default)
            // 成功した場合は音声セッションをアクティブにする（true）
            try session.setActive(true)
        } catch {
            // エラーが発生した場合は、エラーを表示
            print("AVAudioSession設定エラー: \(error)")
        }
    } // configureAudioSession()
}  // MeditatingSetViewModel
extension MeditatingSetViewModel {
    /// 瞑想タイマー状態の管理
    enum TimerState {
        case idle // 開始前の待機状態
        case preStart  // 瞑想前タイマーカウントダウン
        case prePause  // 瞑想前タイマー中断
        case start  // 瞑想タイマーカウントダウン
        case pause  // 瞑想タイマー中断
        case end  // 瞑想終了
        case suspended  // 画面を離れたため一時停止
    }  // enum Stateここまで
}
