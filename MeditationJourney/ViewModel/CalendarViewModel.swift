//
//  CalendarViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2025/07/21.
//

import CoreData
import SwiftUI

// MARK: - DayCell
/// 表示月の1日の情報を格納する構造体
struct DayCell: Identifiable {
    // 一意の識別子（SwiftUIのForEachで使用）
    let id = UUID()
    // 日付の日部分（1-31）
    let day: Int
    // 現在表示中の月に属するかどうか
    let isCurrentMonth: Bool
    // 今日の日付かどうか
    let isToday: Bool
    // その日の瞑想時間（分）
    let meditationTime: Int
    // テキストの色を決定（今日はライム色、それ以外は白色）
    var textColor: Color {
        isToday ? .dateInTodayLime : .keyWhite
    }
    // 背景色を決定（瞑想時間に応じて変化）
    var backgroundColor: Color {
        Color.backgroundStyle(for: meditationTime)
    }
}

class CalendarViewModel: ObservableObject {
    // MARK: - Published Properties
    /// 現在表示中の年月を管理する状態変数、初期値は今日の日付
    @Published private(set) var displayDate: Date = Date()
    /// CoreDataから取得した瞑想記録を格納する配列
    private(set) var meditationRecords: [MeditationInfo] = []
    /// カレンダー表示用の日付セル情報を格納する配列
    @Published private(set) var dayCells: [DayCell] = []
    /// ヘッダー表示用の年
    var displayYear: Int {
        calendar.component(.year, from: displayDate)
    }
    /// ヘッダー表示用の月
    var displayMonth: Int {
        calendar.component(.month, from: displayDate)
    }
    // MARK: - Private Properties
    /// CoreDataの操作に必要なコンテキストを保持
    private let context: NSManagedObjectContext
    /// 日付計算に使用するカレンダーオブジェクト
    private let calendar = Calendar.current
    // カレンダーグリッドの総日数（6週間 × 7日 = 42日）
    private let totalCalendarDays: Int = 42
    // MARK: - Initialization
    /// CoreDataのコンテキストを受け取るイニシャライザー
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        // 受け取ったコンテキストを保存
        self.context = context
    }
    // MARK: - CoreData Methods
    /// 指定された月の瞑想記録をCoreDataから取得する（NSPredicateで月別フィルタリングを適用）
    func fetchMeditationRecords(in month: Date) {
        // MeditationInfoエンティティのフェッチリクエストを作成
        let request: NSFetchRequest<MeditationInfo> = MeditationInfo.fetchRequest()
        // 指定月の開始日を計算
        guard let startOfMonth = month.startOfMonth() else {
            meditationRecords = []
            return
        }
        // 翌月の開始日を計算
        guard let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: startOfMonth)
        else {
            meditationRecords = []
            return
        }
        // 月別フィルタリングの条件を設定
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@", startOfMonth as NSDate, nextMonthStart as NSDate)
        // 日付の昇順でソートする設定を追加
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MeditationInfo.date, ascending: true)]
        do {
            // CoreDataから指定月の瞑想記録を取得
            let records = try context.fetch(request)
            // 取得した記録をプロパティに保存
            meditationRecords = records
        } catch {
            // エラーが発生した場合
            // 空の配列を設定
            meditationRecords = []
            print("瞑想記録の取得に失敗: \(error)")
        }
    }
    // MARK: - Helper Functions
    /// 日付に応じた瞑想時間の設定 計算した結果を格納する
    /// 同じ日付の複数の瞑想記録がある場合、時間を合計して返す
    func calculateDailyMeditationTotals(for records: [MeditationInfo]) -> [Date: Int] {
        // 日付でグループ化して、同じ日付の瞑想時間を合計
        let totals = Dictionary(
            grouping: records,
            by: { record in
                // 瞑想記録の日付を取得（nilの場合は現在の日付を使用）
                guard let recordDate = record.date else { return Date() }
                // 時刻を無視して日付のみ（年月日）でグループ化
                return calendar.startOfDay(for: recordDate)
            }
        ).mapValues { records in
            // 同じ日付の複数の瞑想記録の時間を合計
            records.reduce(0) { $0 + Int($1.meditationTime) }
        }
        return totals
    }
    // MARK: - Data Update Methods
    /// カレンダーデータと瞑想記録を更新する
    func updateCalendarCells() {
        // 表示中の月の瞑想記録を取得
        fetchMeditationRecords(in: displayDate)
        // 指定月のカレンダー日付配列を生成
        var result: [(date: Date, meditationTime: Int)] = createCalendarDates(for: displayDate)
        // カレンダーグリッドを6週間（42日）で統一するため、不足分をダミーで補完
        while result.count < totalCalendarDays {
            // 最後の日付から1日ずつ追加
            let lastDate = result.last?.date ?? Date()
            // 次の日付を計算
            let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) ?? Date()
            // CoreDataエンティティではなく、通常の構造体を使用してダミーデータを追加
            result.append((date: nextDate, meditationTime: 0))
        }
        // カレンダー表示用の日付セル配列を生成（meditationRecordsは直接変更しない）
        dayCells = result.map { record in
            return DayCell(
                // 日付から日部分を抽出
                day: calendar.component(.day, from: record.date),
                // 表示月と同じ月かどうかを判定
                isCurrentMonth: calendar.isDate(
                    record.date, equalTo: displayDate, toGranularity: .month),
                // 今日の日付かどうかを判定
                isToday: calendar.isDateInToday(record.date),
                // 瞑想時間を設定
                meditationTime: record.meditationTime
            )
        }
    }
    /// 指定月のカレンダー日付配列を生成するメソッド
    /// 前月・翌月のオフセット日付も含めて完全なカレンダーグリッドを作成
    func createCalendarDates(for date: Date) -> [(date: Date, meditationTime: Int)] {
        // 日付ごとの合計瞑想時間を事前に計算
        let dailyMeditationTotals = calculateDailyMeditationTotals(for: meditationRecords)
        // 指定された日付の月の開始日を取得
        guard let startOfMonth = date.startOfMonth(),
              // 指定された日付の月の日数を取得
              let daysInMonth = date.daysInMonth(),
              // 指定された日付の月の最初の曜日を取得
              let startWeekday = startOfMonth.weekday() else {
            return []
        }
        // 指定月のカレンダー日付を格納する配列
        var days = [(date: Date, meditationTime: Int)]()
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
            // 計算済みの合計瞑想時間から該当日の時間を取得（見つからない場合は0分）
            // 時刻を無視して日付のみで比較（例：2時22分22秒と2時33分33秒は同じ日として扱われる）
            let meditationTime = dailyMeditationTotals[calendar.startOfDay(for: currentDate)] ?? 0
            // 今月の開始日から1日ずつ加算した日付と瞑想時間を配列に追加
            days.append((date: currentDate, meditationTime: meditationTime))
        }  // for day in（今月の日付ループ）終了
        // 最初と最後の日付を取得して週のオフセットを計算
        // 初週のオフセット日数を計算（月の開始日が何曜日かによって前月の日付を何日分表示するか）
        let firstWeekEmptyDays = startWeekday - 1
        // 最終週のオフセット日数を計算（月の開始日が何曜日かによって翌月の日付を何日分表示するか）
        let lastWeekEmptyDays = 7 - startWeekday
        // 初週のオフセットを配列の先頭に追加（前月の日付）
        if firstWeekEmptyDays > 0 {
            for i in 1...firstWeekEmptyDays {
                // 前月の日付を計算
                let offsetDate =
                calendar.date(
                    byAdding: .day, value: -(firstWeekEmptyDays - i + 1), to: startOfMonth)
                ?? Date()
                // 前月の日付を配列の先頭に挿入
                days.insert((date: offsetDate, meditationTime: 0), at: 0)
            }
        }
        // 最終週のオフセットを配列の末尾に追加（翌月の日付）
        if lastWeekEmptyDays > 0 {
            for i in 1...lastWeekEmptyDays {
                // 翌月の日付を計算
                let offsetDate =
                calendar.date(
                    byAdding: .day, value: i,
                    to: calendar.date(
                        byAdding: .day, value: daysInMonth - 1, to: startOfMonth)
                    ?? Date()) ?? Date()
                // 翌月の日付を配列の末尾に追加
                days.append((date: offsetDate, meditationTime: 0))
            }
        }
        // 生成したカレンダー日付配列を返す
        return days
    }  // createCalendarDatesメソッド終了
    // MARK: - Navigation Methods
    /// 前月に移動する
    func moveToPreviousMonth() {
        // 現在の表示日付から1ヶ月前の日付を計算
        if let newDate = calendar.date(byAdding: .month, value: -1, to: displayDate) {
            // 表示日付を更新
            displayDate = newDate
            // カレンダー表示を更新
            updateCalendarCells()
        }
    }
    /// 翌月に移動する
    func moveToNextMonth() {
        // 現在の表示日付から1ヶ月後の日付を計算
        if let newDate = calendar.date(byAdding: .month, value: 1, to: displayDate) {
            // 表示日付を更新
            displayDate = newDate
            // カレンダー表示を更新
            updateCalendarCells()
        }
    }
}
