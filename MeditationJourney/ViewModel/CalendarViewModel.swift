//
//  CalendarViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2025/07/21.
//

import CoreData
import SwiftUI

class CalendarViewModel: ObservableObject {
    // CoreDataのコンテキストを取得
    private let context: NSManagedObjectContext

    // 現在表示中の年月を管理する状態変数、初期値は今日の日付
    @Published private(set) var displayDate: Date = Date()
    // 瞑想の記録
    @Published private(set) var meditationRecords: [MeditationInfo] = []
    // 日付と瞑想時間の合計を格納する辞書、キーは日付、値は合計時間
    @Published private(set) var checkDates: [Date: Int] = [:]
    // 表示月の各日の情報
    @Published private(set) var dayCells: [DayCell] = []
    // 表示月の1日の情報
    struct DayCell: Identifiable {
        let id = UUID()
        let day: Int
        let isInCurrentMonth: Bool
        let isToday: Bool
        let meditationTime: Int
        var textColor: Color {
            isToday ? .dateInTodayLime : .keyWhite
        }
        var backgroundColor: Color {
            Color.backgroundStyle(for: meditationTime)
        }
    }
    /// カレンダーグリッドの週数（6週間）
    private let calendarWeeks = 6
    /// カレンダーグリッドの総日数（6週間 × 7日 = 42日）
    private var totalCalendarDays: Int {
        return calendarWeeks * 7
    }

    // MARK: - Initialization
    init() {
        // CoreDataのコンテキストを取得
        self.context = PersistenceController.shared.container.viewContext
        // 初回データを読み込み
        fetchMeditationRecords()
        // CoreDataの変化を監視
        observeCoreDataChanges()
    }
    /// 表示用の日付セルデータを更新
    func updateDayCells() {
        let calendar = Calendar.current
        let displayMonth = calendar.component(.month, from: displayDate)
        dayCells = meditationRecords.map { record in
            DayCell(
                day: calendar.component(.day, from: record.date ?? Date()),
                isInCurrentMonth: calendar.component(.month, from: record.date ?? Date())
                    == displayMonth,
                isToday: calendar.isDateInToday(record.date ?? Date()),
                meditationTime: Int(record.meditationTime)
            )
        }
    }
    // MARK: - Helper Functions
    /// 日付に応じた瞑想時間の設定 計算した結果を格納する
    /// 同じ日付の複数の瞑想記録がある場合、時間を合計して返す
    func checkDate(from records: [MeditationInfo]) -> [Date: Int] {
        // 日付でグループ化して、同じ日付の瞑想時間を合計
        let totals = Dictionary(grouping: records, by: { $0.date ?? Date() }).mapValues {
            $0.reduce(0) { $0 + Int($1.meditationTime) }
        }
        return totals
    }
    // MARK: - CoreData Methods
    /// CoreDataから瞑想記録を取得する
    private func fetchMeditationRecords() {
        let request: NSFetchRequest<MeditationInfo> = MeditationInfo.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \MeditationInfo.date, ascending: false)
        ]

        do {
            let records = try context.fetch(request)
            print("Fetched meditation records: \(records.count)件")
            // 取得したデータでカレンダーを更新
            updateCalendarCellsWithRecords(records)
        } catch {
            print("CoreData fetch error: \(error)")
            // エラーが発生した場合は空の配列でカレンダーを更新
            updateCalendarCellsWithRecords([])
        }
    }

    /// CoreDataの変化を監視する
    private func observeCoreDataChanges() {
        NotificationCenter.default.addObserver(
            forName: NSManagedObjectContext.didChangeObjectsNotification,
            object: context,
            queue: .main
        ) { [weak self] notification in
            print("CoreData changed, refetching meditation records...")
            self?.fetchMeditationRecords()
        }
    }

    // MARK: - Data Update Methods
    /// CoreDataから取得した記録でカレンダーを更新する
    private func updateCalendarCellsWithRecords(_ records: [MeditationInfo]) {
        // カレンダー表示用の完全な日付配列（42日分）を生成
        let calendar = Calendar.current
        // 指定月のカレンダー日付を生成
        var result = createCalendarDates(displayDate)
        // カレンダーグリッドを6週間（42日）で統一するため、不足分をダミーで補完
        while result.count < totalCalendarDays {
            // 最後の日付から1日ずつ追加
            let lastDate = result.last?.date ?? Date()
            let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) ?? Date()
            let dummyRecord = MeditationInfo(context: context)
            dummyRecord.date = nextDate
            dummyRecord.worldSounds = nil
            dummyRecord.meditationTime = 0
            result.append(dummyRecord)
        }
        meditationRecords = result
        checkDates = checkDate(from: meditationRecords)
        // 日付セルデータを更新
        updateDayCells()
    }

    /// カレンダーデータと瞑想記録を更新する
    func updateCalendarCells() {
        // CoreDataから最新のデータを取得して更新
        fetchMeditationRecords()
    }
    // 指定月のカレンダー日付配列を生成するメソッド
    // 前月・翌月のオフセット日付も含めて完全なカレンダーグリッドを作成
    func createCalendarDates(_ date: Date) -> [MeditationInfo] {
        let calendar = Calendar.current
        // 月の開始日
        let startOfMonth = date.startOfMonth()
        // 月の日数
        let daysInMonth = date.daysInMonth()
        // CoreDataから実際の瞑想記録を取得
        let request: NSFetchRequest<MeditationInfo> = MeditationInfo.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \MeditationInfo.date, ascending: false)
        ]

        let timeData: [MeditationInfo]
        do {
            timeData = try context.fetch(request)
        } catch {
            print("CoreData fetch error in createCalendarDates: \(error)")
            timeData = []
        }
        // 指定月のカレンダー日付を格納する配列
        var days = [MeditationInfo]()
        // 今月の全ての日付をループして処理
        for day in 1...daysInMonth {
            // 今月の開始日から1日ずつ加算した日付を計算
            guard
                let currentDate = calendar.date(
                    byAdding: .day, value: day - 1, to: startOfMonth)
            else {
                // 日付が計算できない場合は処理をスキップ
                continue
            }
            // サンプルデータからcurrentDateと同じ日付の瞑想時間を検索
            let meditationTime =
                timeData.first(where: { record in
                    // recordDate が currentDate と同じ日（年月日）か確認
                    calendar.isDate(record.date ?? Date(), inSameDayAs: currentDate)
                    // 見つからない場合は0分を設定
                })?.meditationTime ?? 0
            // 今月の開始日から1日ずつ加算した日付と瞑想時間を配列に追加
            let record = MeditationInfo(context: context)
            record.date = currentDate
            record.worldSounds = nil
            record.meditationTime = Int32(meditationTime)
            days.append(record)
        }  // for day in（今月の日付ループ）終了
        // 最初と最後の日付を取得して週のオフセットを計算
        // 初週のオフセット日数を計算（月の開始日が何曜日かによって前月の日付を何日分表示するか）
        let firstWeekEmptyDays = startOfMonth.weekday() - 1
        // 最終週のオフセット日数を計算（月の最終日が何曜日かによって翌月の日付を何日分表示するか）
        let lastWeekEmptyDays = 7 - startOfMonth.weekday()
        // 初週のオフセットを配列の先頭に追加（前月の日付）
        if firstWeekEmptyDays > 0 {
            for i in 1...firstWeekEmptyDays {
                let offsetDate =
                    calendar.date(
                        byAdding: .day, value: -(firstWeekEmptyDays - i + 1), to: startOfMonth)
                    ?? Date()
                let offsetRecord = MeditationInfo(context: context)
                offsetRecord.date = offsetDate
                offsetRecord.worldSounds = nil
                offsetRecord.meditationTime = 0
                days.insert(offsetRecord, at: 0)
            }
        }
        // 最終週のオフセットを配列の末尾に追加（翌月の日付）
        if lastWeekEmptyDays > 0 {
            for i in 1...lastWeekEmptyDays {
                let offsetDate =
                    calendar.date(
                        byAdding: .day, value: i,
                        to: calendar.date(
                            byAdding: .day, value: daysInMonth - 1, to: startOfMonth)
                            ?? Date()) ?? Date()
                let lastOffsetRecord = MeditationInfo(context: context)
                lastOffsetRecord.date = offsetDate
                lastOffsetRecord.worldSounds = nil
                lastOffsetRecord.meditationTime = 0
                days.append(lastOffsetRecord)
            }
        }
        return days
    }  // createCalendarDatesメソッド終了
    // MARK: - Navigation Methods
    /// 前月に移動する
    func moveToPreviousMonth() {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: -1, to: displayDate) {
            displayDate = newDate
            updateCalendarCells()
        }
    }
    /// 翌月に移動する
    func moveToNextMonth() {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: 1, to: displayDate) {
            displayDate = newDate
            updateCalendarCells()
        }
    }
}
