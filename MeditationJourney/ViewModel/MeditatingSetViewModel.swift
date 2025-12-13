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
    let trackID: String = "848536284"
    /// プレイヤー
    private var audioPlayer: AVPlayer?
    /// 設定画面へ誘導するアラート
    @Published var isShowAlert = false
    /// タイマー
    var timer: Timer?
    /// タイマーの終了時刻を管理する変数
    private var meditationEndDate: Date?
    /// タイマーの終了時刻を管理する変数
    private var endTime: Date?
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
        // 終了時刻は、残り時間+1秒を考慮
        endTime = Date().addingTimeInterval(TimeInterval(remainingSeconds + 1))
        // タイマー起動
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // preStartのとき
            if timerState == .preStart {
                // endTimeが存在するとき
                if let endTime = self.endTime {
                    // 現在時刻と終了時刻の差を評価し、0以上の値を返す
                    let remainigTimeInterval = max(0, endTime.timeIntervalSince(Date()))
                    // Int型に変換してremainingSecondsに格納
                    remainingSeconds = Int(remainigTimeInterval)
                    // remainingSecondsが0以下のとき
                    if remainingSeconds <= 0 {
                        updateTimerState(to: .start)
                        stopTimer()
                    }
                }  // else ifここまで
            }  // if state == .preStartここまで
        }  // timerHandlerここまで
    }  // funcここまで
    // 瞑想中タイマー
    func startMeditationTimer() {
        // 多重でタイマーを開始しないようにタイマー停止をする
        stopTimer()
        // remainingSecondsが0より大きとき
        guard remainingSeconds > 0 else {
            return
        }
        // 終了時刻は、残り時間+1秒を考慮
        endTime = Date().addingTimeInterval(TimeInterval(remainingSeconds + 1))
        // 音再生
        updatePlaybackState(to: .playing)
        // タイマー起動
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // 瞑想中なら
            if timerState == .start {
                // endTimeが存在するとき
                if let endTime = self.endTime {
                    // 現在時刻と終了時刻の差を評価し、0以上の値を返す
                    let remainigTimeInterval = max(0, endTime.timeIntervalSince(Date()))
                    // Int型に変換してremainingSecondsに格納
                    remainingSeconds = Int(remainigTimeInterval)
                    // remainingSecondsが0以下のとき
                    if remainingSeconds <= 0 {
                        // end
                        timerState = .end
                        // 音の停止
                        updatePlaybackState(to: .stopped)
                        // タイマー停止
                        stopTimer()
                    } // if remainingSeconds <= 0
                }  // if let endTime
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
            // end状態にする
            timerState = .end
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
        case .paused:
            // 曲を一時停止
            audioPlayer?.pause()
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
        guard let previewURL else {
            print("previewURLが存在しません")
            print("playBack2")
            // 処理終了
            return
        }  // guard let
        // playerがnilのとき（初めての再生のとき）
        if audioPlayer == nil {
            // playerにpreviewUrlを代入する
            audioPlayer = AVPlayer(url: previewURL)
//            // ボリュームを0に設定
//            audioPlayer?.volume = 0.0
            // 再生する
            audioPlayer?.play()
        } else {
            // 再生するのみ
            audioPlayer?.play()
        }  // if player
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
