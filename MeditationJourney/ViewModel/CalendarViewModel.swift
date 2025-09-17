//
//  CalendarViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2025/07/21.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    // 現在表示中の年月を管理する状態変数、初期値は今日の日付
    @Published private(set) var displayDate: Date = Date()
    // 瞑想の記録
    @Published private(set) var meditationRecords: [MeditationInfo] = []
    // 表示月の各日の情報
    @Published private(set) var dayCells: [DayCell] = []
    
    private let calendar = Calendar.current
    
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
    /// カレンダーグリッドの総日数（6週間 × 7日 = 42日）
    private let totalCalendarDays: Int = 42
    
    // MARK: - Data Update Methods
    /// カレンダーデータと瞑想記録を更新する
    func updateCalendarCells() {
        // 日付と瞑想時間の配列を取得するメソッド
        // 指定月のカレンダー日付を生成
        var result = createCalendarDates(displayDate)
        // カレンダーグリッドを6週間（42日）で統一するため、不足分をダミーで補完
        while result.count < totalCalendarDays {
            // 最後の日付から1日ずつ追加
            let lastDate = result.last?.date ?? Date()
            let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) ?? Date()
            result.append(MeditationInfo(date: nextDate, worldSounds: nil, meditationTime: 0))
        }
        meditationRecords = result
        
        /// 表示用の日付セルデータを更新
        dayCells = meditationRecords.map { record in
            DayCell(
                day: calendar.component(.day, from: record.date),
                isInCurrentMonth: calendar.isDate(record.date, equalTo: displayDate, toGranularity: .month),
                isToday: calendar.isDateInToday(record.date),
                meditationTime: record.meditationTime
            )
        }
    }
    // 指定月のカレンダー日付配列を生成するメソッド
    // 前月・翌月のオフセット日付も含めて完全なカレンダーグリッドを作成
    func createCalendarDates(_ date: Date) -> [MeditationInfo] {
        // 月の開始日
        let startOfMonth = date.startOfMonth()
        // 月の日数
        let daysInMonth = date.daysInMonth()
        
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let dayBeforeYesterday = calendar.date(byAdding: .day, value: -2, to: today) ?? today
        
        // 瞑想時間のサンプルデータ（実際のアプリではデータベースから取得）
        let timeData = [
            // 今日の瞑想時間（40分）
            MeditationInfo(date: today, worldSounds: nil, meditationTime: 40),
            // 昨日の瞑想時間（10分）
            MeditationInfo(
                date: yesterday,
                worldSounds: nil,
                meditationTime: 10),
            // 一昨日の瞑想時間（60分）
            MeditationInfo(
                date: dayBeforeYesterday,
                worldSounds: nil,
                meditationTime: 60)
        ]
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
                calendar.isDate(record.date, inSameDayAs: currentDate)
                // 見つからない場合は0分を設定
            })?.meditationTime ?? 0
            // 今月の開始日から1日ずつ加算した日付と瞑想時間を配列に追加
            days.append(
                MeditationInfo(
                    date: currentDate,
                    worldSounds: nil,
                    meditationTime: meditationTime))
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
                days.insert(
                    MeditationInfo(date: offsetDate, worldSounds: nil, meditationTime: 0), at: 0)
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
                days.append(MeditationInfo(date: offsetDate, worldSounds: nil, meditationTime: 0))
            }
        }
        return days
    }  // createCalendarDatesメソッド終了
    // MARK: - Navigation Methods
    /// 前月に移動する
    func moveToPreviousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: displayDate) {
            displayDate = newDate
            updateCalendarCells()
        }
    }
    /// 翌月に移動する
    func moveToNextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: displayDate) {
            displayDate = newDate
            updateCalendarCells()
        }
    }
}
