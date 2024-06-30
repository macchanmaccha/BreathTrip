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
    private let year = Calendar.current.year(from: Date())
    // 現在の月
    private let month = Calendar.current.month(from: Date())
    // 日付の配列
    private let calendarDates = createCalendarDates(Date())
    // 曜日
    private let weekdays = Calendar.current.shortWeekdaySymbols
    // グリッドアイテム
    private let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 40, maximum: 80)), count: 7)
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景色を紺色に設定
                Color("backgroundNavy")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    // 現在の年月が存在すれば
                    if let currentYear = year,
                       let currentMonth = month, false {
                        // 年月の表示
                        Text(String(format: "< %04d/%02d >", currentYear, currentMonth))
                            .foregroundColor(Color(.keyWhite))
                            .bold()
                        // フォントサイズは30
                            .font(.title)
                            .minimumScaleFactor(0.5)
                        LazyVGrid(columns: columns) {
                            // 曜日のループ
                            ForEach(weekdays, id: \.self) { weekday in
                                Text(weekday)
                                    .foregroundColor(Color(.keyWhite))
                                    .lineLimit(1)
                                // 文字サイズ
                                    .font(.headline)
                                    .bold()
                                // フレーム
                                    .frame(minWidth: 45, minHeight: 45)
                            } // ForEachここまで
                        } // LazyVGridここまで
                        LazyVGrid(columns: columns, spacing: geometry.size.height * 0.03) {
                            // それぞれの日付をループで処理
                            ForEach(calendarDates) { calendarDate in
                                // 日付が存在する場合、日を表示
                                if let date = calendarDate.date,
                                   let day = Calendar.current.day(from: date) {
                                    ZStack {
                                        // 日付表示
                                        Text("\(day)")
                                        // 文字サイズ
                                            .font(.title2)
                                            .bold()
                                        // 今日の日付はライム色、その他はキーホワイト
                                            .foregroundColor(Calendar.current.isDateInToday(date) ? Color(.dateInTodayLime) : Color(.keyWhite))
                                        // サイズ
                                            .frame(minWidth: 45, minHeight: 60)
                                        // 瞑想時間に応じた背景色
                                            .background(Color.backgroundColor(for: calendarDate.meditationTime))
                                        // 角の丸み
                                            .cornerRadius(10)
                                    } // ZStackここまで
                                    // 日付が存在しない時
                                } else {
                                    // 何も表示しない
                                    Text("")
                                } // if let　ここまで
                            } // ForEachここまで
                        } // LazyVGridここまで
                        // 色の説明　LessからMoreまで
                        HStack {
                            // 右寄せ
                            Spacer()
                            Text("Less")
                                .foregroundColor(Color(.keyWhite))
                            Rectangle()
                                .border(.gray, width: 1.5)
                                .frame(maxWidth: 20, maxHeight: 25 )
                                .foregroundColor(.clear)
                                .cornerRadius(4)
                            Rectangle()
                                .border(.gray, width: 1.5)
                                .frame(maxWidth: 20, maxHeight: 25 )
                                .foregroundColor(Color(.firstStageBlue))
                                .cornerRadius(4)
                            Rectangle()
                                .border(.gray, width: 1.5)
                                .frame(maxWidth: 20, maxHeight: 25 )
                                .foregroundColor(Color(.secondStageBlue))
                                .cornerRadius(4)
                            Rectangle()
                                .border(.gray, width: 1.5)
                                .frame(maxWidth: 20, maxHeight: 25 )
                                .foregroundColor(Color(.thirdStageBlue))
                                .cornerRadius(4)
                            Text("More")
                                .foregroundColor(Color(.keyWhite))
                        } // HStackここまで
                    } else {
                        // 現在の年月が存在しなければ
                        Text("カレンダーを表示できません。\nアプリを再起動してください。")
                            .foregroundColor(Color(.keyWhite))
                            .bold()
                        // フォントサイズは30
                            .font(.title)
                            .minimumScaleFactor(0.5)
                    } // if letここまで
                } // VStackここまで
            } // ZStackここまで
        } // geometryここまで
    } // bodyここまで
} // CalendarViewここまで

private func createCalendarDates(_ date: Date) -> [CalendarDates] {
    // 日付配列プロパティ
    var days = [CalendarDates]()
    // 月の初めの日付と月の日数がなければ
    guard let startDateOfMonth = Calendar.current.startDateOfMonth(from: date),
          let daysInMonth = Calendar.current.daysInMonth(from: date) else {
        // 何も返却しない
        return []
    } // guard let ここまで
    // 今月の全ての日付
    for day in 0..<daysInMonth {
        // ランダムな瞑想時間を設定
        let meditationTime = Int.random(in: 0...60)
        // 今月の開始日から1日ずつ加算
        days.append(CalendarDates(date: Calendar.current.date(byAdding: .day, value: day, to: startDateOfMonth), meditationTime: meditationTime))
    } // for day inここまで
    // 最初と最後の日付を取得
    // 最初の日と最後の日
    guard let firstDay = days.first?.date, let lastDay = days.last?.date,
          // 最初の日の曜日
          let firstDateWeekday = Calendar.current.weekday(from: firstDay),
          // 最後の日の曜日
          let lastDateWeekday = Calendar.current.weekday(from: lastDay) else {
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
