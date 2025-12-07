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
    /// 再生状態　初期は.stopped
    private var playbackState: PlaybackState = .stopped
    /// プレビューURL
    private var previewURL: URL?
    /// 曲のID
    private let trackID: String = "848536284"
    /// プレイヤー
    private var audioPlayer: AVPlayer?
    /// 設定画面へ誘導するアラート
    private var isShowAlert = false
    /// タイマー
    var timer: Timer?
    /// 瞑想開始日時を記録する変数
    private var meditationStartDate: Date?
    // 瞑想タイマーの終了時刻
    private var meditationEndTime: Date?
    /// 30秒ごとの繰り返し再生を管理するタイマー
    private var repeatTimer: Timer?
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // preStartのとき
            if timerState == .preStart {
                // 1より大きいとき
                if remainingSeconds > 1 {
                    // 1ずつマイナス
                    remainingSeconds -= 1
                    // 1の場合（0秒となる前）
                } else if remainingSeconds == 1 {
                    updateTimerState(to: .start)
                    // タイマーが有効かチェック
                }  // else ifここまで
            }  // if state == .preStartここまで
        }  // timerHandlerここまで
    }  // funcここまで
    // 瞑想中タイマー
    func startMeditationTimer() {
        // 多重でタイマーを開始しないようにタイマー停止をする
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // 瞑想中なら
            if timerState == .start {
                // 1秒より大きいとき
                if remainingSeconds > 1 {
                    // マイナス1ずつしていく
                    remainingSeconds -= 1
                    // 1の場合（0秒となる前）
                } else if remainingSeconds == 1 {
                    // end
                    timerState = .end
                }  // else ifここまで
            }  // if state == .startここまで
        }  // timerHandlerここまで
    }  // startMeditationTimer
    /// タイマー停止・無効
    func stopTimer() {
        // タイマー停止
        timer?.invalidate()
        // タイマー無効
        timer = nil
    }
#if DEBUG
    /// 画面タップで終了
    func forceEndForDebug() {
        // 瞑想中の場合に実行
        if timerState == .start {
            // 残り時間を1秒に設定
            remainingSeconds = 1
        }
    }
#endif
    /// 音の設定
    override func setSelectedSoundName(soundName: SoundModel) {
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
            // selectedDurationMinutesTimerを無効、nil
//            stopTimer(timer: &selectedDurationMinutesTimer)
            // fadeOutEndTimerを無効、nilにする
//            stopTimer(timer: &fadeOutEndTimer)
        case .paused:
            // 曲を一時停止
            audioPlayer?.pause()
            // selectedDurationMinutesTimerを無効、nil
//            stopTimer(timer: &selectedDurationMinutesTimer)
//            // fadeOutEndTimerを無効、nilにする
//            stopTimer(timer: &fadeOutEndTimer)
//            // fadeOutTimerを無効、nilにする
//            stopTimer(timer: &fadeOutTimer)
        }  // switch newState
        playbackState = to
    }
    func fetchPreviewURL(for trackID: String) async {
        // エラーを出すメソッドを安全に返す(request)
        do {
            // Apple Musicの認証ステータス
            let musicAuthorizationStatus = await MusicAuthorization.request()
            // 認証されなかったら
            guard musicAuthorizationStatus == .authorized else {
                // アラート表示
                isShowAlert = true
                // 処理終了　なにもしない
                print("許可されませんでした")
                return
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
                print("previewURLの取得完了！")
            }  // if let
            // エラーの場合
        } catch {
            print("指定したトラックID（\(trackID)）の曲とpreviewURLがありません")
            print("エラーはこちら: \(error)")
            return
        }  // do catch
    }  // fetchPreviewURL
    // 曲を再生するメソッド
    private func playBack() {
        print("playBack1")
        // previewURL、fadeOutEndTimeが存在しなかったら
        guard let previewURL
//            ,let fadeOutEndTime
        else {
            print("previewURLが存在しません")
            print("playBack2")
            // 処理終了
            return
        }  // guard let
        // playerがnilのとき（初めての再生のとき）
        if audioPlayer == nil {
            print("playBack3")
            print("🙆新しいプレーヤーを取得しました！")
            // playerにpreviewUrlを代入する
            audioPlayer = AVPlayer(url: previewURL)
//            // ボリュームを0に設定
//            audioPlayer?.volume = 0.0
            // 再生する
            audioPlayer?.play()
            print("playBack4")
            print("🍀プレイヤーの状態は\(String(describing: audioPlayer?.status.rawValue))")
            print("📣ボリュームは\(String(describing: audioPlayer?.volume))")
//            // フェードイン
//            fadeIn(player: audioPlayer!, duration: 5)
//            print("playBack5")
        } else {
//            print("playBack6")
//            // 再開したとき
//            print("🌸一時停止した後の再開だよ！")
            // 再生するのみ
            audioPlayer?.play()
            print("playBack7")
        }  // if player
        print("playBack8")
    }  // func playBack()
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
