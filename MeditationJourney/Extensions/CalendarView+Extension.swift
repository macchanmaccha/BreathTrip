//
//  CalendarView+Extension.swift
//  MeditationJourney
//
//  Created by apple on 2025/07/27.
//

import SwiftUI

extension CalendarView {
    // 指定月のカレンダー日付配列を生成するメソッド
    // 前月・翌月のオフセット日付も含めて完全なカレンダーグリッドを作成
    func createCalendarDates(_ date: Date) -> [CalendarInfo] {
        // 瞑想時間のサンプルデータ（実際のアプリではデータベースから取得）
        let timeData = [
            // 今日の瞑想時間（40分）
            CalendarInfo(date: Date(), meditationTime: 40),
            // 昨日の瞑想時間（10分）
            CalendarInfo(
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                meditationTime: 10),
            // 一昨日の瞑想時間（60分）
            CalendarInfo(
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                meditationTime: 60),
        ]
        // 指定月のカレンダー日付を格納する配列
        var days = [CalendarInfo]()
        // 今月の全ての日付をループして処理
        for day in 0..<date.daysInMonth {
            // 今月の開始日から1日ずつ加算した日付を計算
            guard
                let currentDate = Calendar.current.date(
                    byAdding: .day, value: day, to: date.startOfMonth)
            else {
                // 日付が計算できない場合は処理をスキップ
                continue
            }
            // サンプルデータからcurrentDateと同じ日付の瞑想時間を検索
            let meditationTime =
                timeData.first(where: { record in
                    // recordDate が currentDate と同じ日（年月日）か確認
                    Calendar.current.isDate(record.date, inSameDayAs: currentDate)
                    // 見つからない場合は0分を設定
                })?.meditationTime ?? 0
            // 今月の開始日から1日ずつ加算した日付と瞑想時間を配列に追加
            days.append(
                CalendarInfo(
                    date: Calendar.current.date(byAdding: .day, value: day, to: date.startOfMonth)!,
                    meditationTime: meditationTime))
        }  // for day in（今月の日付ループ）終了
        // 最初と最後の日付を取得して週のオフセットを計算
        // 初週のオフセット日数を計算（月の開始日が何曜日かによって前月の日付を何日分表示するか）
        let firstWeekEmptyDays = date.startOfMonth.weekday - 1
        // 最終週のオフセット日数を計算（月の最終日が何曜日かによって翌月の日付を何日分表示するか）
        let lastWeekEmptyDays = 7 - date.startOfMonth.weekday
        // 初週のオフセットを配列の先頭に追加（前月の日付）
        for i in 0..<firstWeekEmptyDays {
            let offsetDate =
                Calendar.current.date(
                    byAdding: .day, value: -(firstWeekEmptyDays - i), to: date.startOfMonth)
                ?? Date()
            days.insert(CalendarInfo(date: offsetDate, meditationTime: 0), at: 0)
        }
        // 最終週のオフセットを配列の末尾に追加（翌月の日付）
        for i in 0..<lastWeekEmptyDays {
            let offsetDate =
                Calendar.current.date(
                    byAdding: .day, value: i + 1,
                    to: Calendar.current.date(
                        byAdding: .day, value: date.daysInMonth - 1, to: date.startOfMonth)
                        ?? Date()) ?? Date()
            days.append(CalendarInfo(date: offsetDate, meditationTime: 0))
        }
        return days
    }  // createCalendarDatesメソッド終了
}
