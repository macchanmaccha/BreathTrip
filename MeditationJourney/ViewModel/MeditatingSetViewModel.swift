//
//  MeditatingSetViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/12/25.
//

import CoreData
import SwiftUI

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
    /// タイマー停止・無効
    func stopTimer() {
        // タイマー停止
        timer?.invalidate()
        // タイマー無効
        timer = nil
    }
    func startPlayAndTimer() {
        // 多重でタイマーを開始しないようにする
        stopTimer()
        // fadeOutの終了時刻は、fadeOutTimeを考慮
        fadeOutEndTime = Date().addingTimeInterval(fadeOutTime)
        // 再生を開始
        playBack()
        // タイマーを開始
        startMeditationTimer()
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
