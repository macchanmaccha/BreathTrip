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
    @Published private(set) var state: State = .end
    /// 瞑想中または音再生タイマーの分数・秒数を管理する変数
    @Published private(set) var remainingSeconds: Int = 0
    /// タイマー
    var timer: Timer?
    /// 瞑想開始日時を記録する変数
    private var meditationStartDate: Date?
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    // タイマーの初期値(瞑想前タイマー5秒)をセット
    func setFirstTimer() {
        remainingSeconds = 5
    }
    // 状態の更新
    func updateState(to: State) {
        if state == .preStart && to == .start {
            // 瞑想タイマーをセット
            remainingSeconds = meditationMinutes * 60
            // 瞑想開始時刻を記録
            meditationStartDate = Date()
        }
        state = to
    }
    // 瞑想前タイマー
    func startPreparationTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // preStartのとき
            if state == .preStart {
                // 1より大きいとき
                if remainingSeconds > 1 {
                    // 1ずつマイナス
                    remainingSeconds -= 1
                    // 1の場合（0秒となる前）
                } else if remainingSeconds == 1 {
                    updateState(to: .start)
                    // タイマーが有効かチェック
                    print(
                        "\(#fileID) \(#function) \(#line) \(String(describing: self.timer?.isValid))"
                    )
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
            print("瞑想中タイマー\(#fileID) \(#function) \(#line)")
            // 瞑想中なら
            if state == .start {
                // 1秒より大きいとき
                if remainingSeconds > 1 {
                    // マイナス1ずつしていく
                    remainingSeconds -= 1
                    // 1の場合（0秒となる前）
                } else if remainingSeconds == 1 {
                    // end
                    state = .end
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
    /// 音の設定
    override func setSelectedSoundName(soundName: SoundModel) {
        meditationSoundName = soundName
        saveMeditationSound()
        saveMeditationMinutes()
    }
    // MARK: - Data Management Methods
    /// 瞑想記録をCoreDataに保存するメソッド
    func saveMeditationRecord() {
        // 新しいMeditationInfoエンティティを作成
        let newMeditation = MeditationInfo(context: context)
        // データを設定
        // 瞑想開始日（カレンダー表示用）
        newMeditation.date = meditationStartDate ?? Date()
        // 瞑想時間（分）
        newMeditation.meditationTime = Int32(meditationMinutes)
        // 世界の音
        newMeditation.worldSounds = meditationSoundName.rawValue
        // デバッグ用：保存するデータの詳細を出力
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        print("=== 瞑想記録を保存します ===")
        print("日付: \(formatter.string(from: newMeditation.date ?? Date()))")
        print("瞑想時間: \(newMeditation.meditationTime)分")
        print("音の種類: '\(newMeditation.worldSounds ?? "nil")'")
        // 保存処理
        do {
            try context.save()
            print("✅ 瞑想記録を保存しました")
            // 保存後に全記録を確認（デバッグ用）
            let request: NSFetchRequest<MeditationInfo> = MeditationInfo.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \MeditationInfo.date, ascending: false)
            ]
            let allRecords = try context.fetch(request)
            print("=== 現在の瞑想記録一覧（全\(allRecords.count)件） ===")
            if allRecords.isEmpty {
                print("記録がありません")
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年M月d日"
                for (index, record) in allRecords.enumerated() {
                    let recordDate = record.date ?? Date()
                    let recordWorldSounds = record.worldSounds ?? "音の種類不明"
                    print(
                        "\(index + 1). 日付: \(formatter.string(from: recordDate)), 瞑想時間: \(record.meditationTime)分, 音の種類: '\(recordWorldSounds)'"
                    )
                }
            }
            print("=== 一覧終了 ===")

        } catch {
            print("❌保存に失敗しました: \(error)")
        }
    }
}  // MeditatingSetViewModel
extension MeditatingSetViewModel {
    /// 状態の管理
    enum State {
        case preStart  // 瞑想前タイマーカウントダウン
        case prePause  // 瞑想前タイマー中断
        case start  // 瞑想タイマーカウントダウン
        case pause  // 瞑想タイマー中断
        case end  // 瞑想終了
    }  // enumここまで
}
