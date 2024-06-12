////
////  CalendarView.swift
////  MeditationJourney
////
////  Created by apple on 2023/09/17.
////
import SwiftUI

/// カレンダーの日付を表す構造体
struct CalendarDates: Identifiable {
    // 識別子
    var id = UUID()
    // 日付
    var date: Date?
    // 瞑想時間
    var meditationTime: Int
} // CalendarDatesここまで

struct CalendarView: View {
    // 現在の年
    private let year = Calendar.current.year(for: Date()) ?? 0
    // 現在の月
    private let month = Calendar.current.month(for: Date()) ?? 0
    // 日付の配列
    private let calendarDates = createCalendarDates(Date())
    // 曜日
    private let weekdays = Calendar.current.shortWeekdaySymbols
    // グリッドアイテム
    private let columns: [GridItem] = Array(repeating: .init(.fixed(50)), count: 7)
    var body: some View {
        ZStack {
            // 背景色を紺色に設定
            Color("backgroundNavy")
                .edgesIgnoringSafeArea(.all)
            VStack {
                // 年月の表示
                Text(String(format: "< %04d/%02d >", year, month))
                    .foregroundColor(Color(.keyWhite))
                    .bold()
                // フォントサイズは30
                    .font(.system(size: 30))
                HStack {
                    // 曜日のループ
                    ForEach(weekdays, id: \.self) { weekday in
                        Text(weekday)
                            .foregroundColor(Color(.keyWhite))
                            .bold()
                        // フレーム
                            .frame(width: 50, height: 50, alignment: .center)
                    } // ForEachここまで
                } // HStackここまで
                LazyVGrid(columns: columns, spacing: 50) {
                    // それぞれの日付をループで処理
                    ForEach(calendarDates) { calendarDate in
                        // 日付が存在する場合、日を表示
                        if let date = calendarDate.date,
                           let day = Calendar.current.day(for: date) {
                            ZStack {
                                // 日付表示
                                Text("\(day)")
                                // 文字サイズ
                                    .font(.system(size: 25))
                                    .bold()
                                // 今日の日付はライム色、その他はキーホワイト
                                    .foregroundColor(Calendar.current.isDateInToday(date) ? Color(.dateInTodayLime) : Color(.keyWhite))
                                // サイズ
                                    .frame(width: 50, height: 50)
                                // 瞑想時間に応じた背景色
                                    .background(Color.backgroundColor(for: calendarDate.meditationTime))
                                // 角の丸み
                                    .cornerRadius(20)
                            } // ZStackここまで
                            // 日付が存在しない時
                        } else {
                            // 何も表示しない
                            Text("")
                            // フレーム
                                .frame(width: 50, height: 50)
                        } // if let　ここまで
                    } // ForEachここまで
                } // LazyVGridここまで
            } // VStackここまで
            // フレーム
            .frame(width: 500, height: 500, alignment: .center)
        } // ZStackここまで
    } // bodyここまで
} // CalendarViewここまで

private func createCalendarDates(_ date: Date) -> [CalendarDates] {
    // 日付配列プロパティ
    var days = [CalendarDates]()
    // 今月の開始日
    let startOfMonth = Calendar.current.startOfMonth(for: date)
    // 今月の日数
    let daysInMonth = Calendar.current.daysInMonth(for: date)
    // 開始日と日数がなければ
    guard let daysInMonth = daysInMonth,
          let startOfMonth = startOfMonth else {
        // 何も返却しない
        return[]
    } // guard let　ここまで
    // 今月の全ての日付
    for day in 0..<daysInMonth {
        // ランダムな瞑想時間を設定
        let meditationTime = Int.random(in: 0...60)
        // 今月の開始日から1日ずつ加算
        days.append(CalendarDates(date: Calendar.current.date(byAdding: .day, value: day, to: startOfMonth), meditationTime: meditationTime))
    } // for day inここまで
    // 最初と最後の日付を取得
    guard let firstDay = days.first, let lastDay = days.last,
          // それぞれ存在するならば
          let firstDate = firstDay.date, let lastDate = lastDay.date,
          // 最初の日の曜日を取得
          let firstDateWeekday = Calendar.current.weekday(for: firstDate),
          // 最後の日の曜日を取得
          let lastDateWeekday = Calendar.current.weekday(for: lastDate) else {
        // なければ何も返却しない
        return []
    } // guard let ここまで
    // 初週のオフセット日数
    let firstWeekEmptyDays = firstDateWeekday - 1
    // 最終週のオフセット日数
    let lastWeekEmptyDays = 7 - lastDateWeekday
    // 初週のオフセットを追加
    for _ in 0..<firstWeekEmptyDays {
        days.insert(CalendarDates(date: nil, meditationTime: 0), at: 0)
    }
    // 最終週のオフセットを追加
    for _ in 0..<lastWeekEmptyDays {
        days.append(CalendarDates(date: nil, meditationTime: 0))
    }
    return days
} // createCalendarDate

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
