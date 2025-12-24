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
    /// 音をきく画面での状態　初期値はend
    @Published private(set) var timerState: TimerState = .end
    /// 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published private(set) var remainingSeconds: Int = 0
    /// 設定画面へ誘導するアラート
    @Published var isShowAlert = false
    /// 曲のID
    let trackID: String = "848536284"
    /// 再生状態　初期は.stopped
    private var playbackState: PlaybackState = .stopped
    /// プレビューURL
    private var previewURL: URL?
    /// プレイヤー
    private var audioPlayer: AVPlayer?
    /// タイマー
    private var timer: Timer?
    /// タイマーの終了時刻を管理する変数
    private var listeningEndTime: Date?
    /// 状態の更新
    func updateTimerState(to: TimerState) {
        if timerState == .end && to == .start {
            // listeningMinutesが0でないとき
            if listeningMinutes != 0 {
                // 音再生タイマーをセット
                remainingSeconds = listeningMinutes * 60
                // listeningMinutesが0のとき
            } else {
                remainingSeconds = 0
            }
        }
        timerState = to
    }
    // 音をきくタイマー
    func startListeningTimer() {
        // 多重でタイマーを開始しないようにタイマー停止をする
        stopTimer()
        // remainingSecondsが0より大きいとき
        guard remainingSeconds > 0 else {
            return
        }
        // 終了時刻は、残り時間+1秒を考慮
        listeningEndTime = Date().addingTimeInterval(TimeInterval(remainingSeconds + 1))
        // タイマー起動
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // 音を聞いている状態なら
            if timerState == .start {
                // endTimeが存在するとき
                if let endTime = self.listeningEndTime {
                    // 現在時刻と終了時刻の差を評価し、0以上の値を返す
                    let remainingTimeInterval = max(0, endTime.timeIntervalSince(Date()))
                    // Int型に変換してremainingSecondsに格納
                    remainingSeconds = Int(remainingTimeInterval)
                    // remainingSecondsが0以下のとき
                    if remainingSeconds <= 0 {
                        // end
                        timerState = .end
                        updatePlaybackState(to: .stopped)
                        // タイマー停止
                        stopTimer()
                    } // if remainingSeconds <= 0
                }  // if let endTime
            }  // if state == .startここまで
        }  // timerHandlerここまで
    }  // startListeningTimer
    /// タイマー停止・無効
    func stopTimer() {
        // タイマー停止
        timer?.invalidate()
        // タイマー無効
        timer = nil
    }  // stopTimer
    /// 時間と音の保存
    override func saveSoundAndMinutes(soundName: SoundModel) {
        listeningSoundName = soundName
        saveListeningSound()
        saveListeningMinutes()
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
            print("ERROR: \(error)")
            return
        }  // do catch
    }  // fetchPreviewURL
    // 曲を再生するメソッド
    private func playBack() {
        // previewURL、fadeOutEndTimeが存在しなかったら
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
    deinit {
        stopTimer()
    }
}  // ListeningSetViewModelここまで
extension ListeningSetViewModel {
    enum TimerState {
        case start  // 音再生タイマーカウントダウン
        case pause  // 音再生タイマー中断
        case end  // 音再生終了
    }  // enumここまで
    // 再生状態を管理する列挙体
    enum PlaybackState {
        // 再生中
        case playing
        // 停止
        case stopped
        // 一時停止
        case paused
    } // enum PlaybackStateここまで
}  // extension ListeningSetViewModelここまで
