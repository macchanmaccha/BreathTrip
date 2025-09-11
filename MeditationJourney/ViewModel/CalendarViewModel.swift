//
//  CalendarViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2025/07/21.
//

import CoreData
import SwiftUI

class CalendarViewModel: ObservableObject {
    // 現在表示中の年月を管理する状態変数、初期値は今日の日付
    @Published private(set) var displayDate: Date = Date()
    // // 瞑想の記録
    // @Published private(set) var meditationRecords: [MeditationInfo] = []
    // // 日付と瞑想時間の合計を格納する辞書、キーは日付、値は合計時間
    // @Published private(set) var checkDates: [Date: Int] = [:]
    /// カレンダーグリッドの週数（6週間）
    private let calendarWeeks = 6
    /// カレンダーグリッドの総日数（6週間 × 7日 = 42日）
    private var totalCalendarDays: Int {
        return calendarWeeks * 7
    }
    // // MARK: - Helper Functions
    // /// 日付に応じた瞑想時間の設定 計算した結果を格納する
    // /// 同じ日付の複数の瞑想記録がある場合、時間を合計して返す
    // func checkDate(from records: [MeditationInfo]) -> [Date: Int] {
    //     // 日付でグループ化して、同じ日付の瞑想時間を合計
    //     let totals = Dictionary(grouping: records, by: { $0.date }).mapValues {
    //         $0.reduce(0) { $0 + $1.meditationTime }
    //     }
    //     return totals
    // }
    // // MARK: - Data Update Methods
    func updateCalendarData() -> [Date] {
        //  //    // 日付と瞑想時間の配列を取得するメソッド
        //  //    // カレンダー表示用の完全な日付配列（42日分）を生成
        //  let calendar = Calendar.current
        //  // 指定月のカレンダー日付を生成
        //  var result = createCalendarDates(displayDate)
        //  // カレンダーグリッドを6週間（42日）で統一するため、不足分をダミーで補完
        //  while result.count < totalCalendarDays {
        //      // 最後の日付から1日ずつ追加
        //      let lastDate = result.last?.date ?? Date()
        //      let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) ?? Date()
        //      result.append(MeditationInfo(date: nextDate, worldSounds: nil, meditationTime: 0))
        //  }
        //  meditationRecords = result
        //  checkDates = checkDate(from: meditationRecords)
        // カレンダー表示用の完全な日付配列（42日分）を生成
        let calendar = Calendar.current
        // 指定月のカレンダー日付を生成
        let result = createCalendarDates(displayDate)
        // カレンダーグリッドを6週間（42日）で統一するため、不足分をダミーで補完
        var calendarDates = result
        while calendarDates.count < totalCalendarDays {
            // 最後の日付から1日ずつ追加
            let lastDate = calendarDates.last ?? Date()
            let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) ?? Date()
            calendarDates.append(nextDate)
        }
        return calendarDates
    }
    // 指定月のカレンダー日付配列を生成するメソッド
    // 前月・翌月のオフセット日付も含めて完全なカレンダーグリッドを作成
    func createCalendarDates(_ date: Date) -> [Date] {
        let calendar = Calendar.current
        // 月の開始日
        let startOfMonth = date.startOfMonth()
        // 月の日数
        let daysInMonth = date.daysInMonth()
        // // 瞑想時間のサンプルデータ（実際のアプリではデータベースから取得）
        // let timeData = [
        //     // 今日の瞑想時間（40分）
        //     MeditationInfo(date: Date(), worldSounds: nil, meditationTime: 40),
        //     // 昨日の瞑想時間（10分）
        //     MeditationInfo(
        //         date: calendar.date(byAdding: .day, value: -1, to: Date())!,
        //         worldSounds: nil,
        //         meditationTime: 10),
        //     // 一昨日の瞑想時間（60分）
        //     MeditationInfo(
        //         date: calendar.date(byAdding: .day, value: -2, to: Date())!,
        //         worldSounds: nil,
        //         meditationTime: 60),
        // ]
        // 指定月のカレンダー日付を格納する配列
        var days = [Date]()
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
            // // サンプルデータからcurrentDateと同じ日付の瞑想時間を検索
            // let meditationTime =
            //     timeData.first(where: { record in
            //         // recordDate が currentDate と同じ日（年月日）か確認
            //         calendar.isDate(record.date, inSameDayAs: currentDate)
            //         // 見つからない場合は0分を設定
            //     })?.meditationTime ?? 0
            //    // 今月の開始日から1日ずつ加算した日付と瞑想時間を配列に追加
            //     days.append(
            //         MeditationInfo(
            //             date: currentDate,
            //             worldSounds: nil,
            //             meditationTime: meditationTime))
            // 今月の開始日から1日ずつ加算した日付を配列に追加
            days.append(currentDate)
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
                // days.insert(
                //     MeditationInfo(date: offsetDate, worldSounds: nil, meditationTime: 0), at: 0)
                days.insert(offsetDate, at: 0)
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
                // days.append(MeditationInfo(date: offsetDate, worldSounds: nil, meditationTime: 0))
                days.append(offsetDate)
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
            updateCalendarData()
        }
    }
    /// 翌月に移動する
    func moveToNextMonth() {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: 1, to: displayDate) {
            displayDate = newDate
            updateCalendarData()
        }
    }
}
