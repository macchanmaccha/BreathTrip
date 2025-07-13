////
////  CalendarView.swift
////  MeditationJourney
////
////  Created by apple on 2023/09/17.
////
import SwiftUI

/// カレンダーの日付を表す構造体
struct CalendarInfo: Identifiable {
    // 識別子
    var id = UUID()
    // 日付（日付は必ず存在するため非オプショナル型）
    var date: Date
    // 瞑想時間
    var meditationTime: Int
} // CalendarDatesここまで

struct CalendarView: View {
    // 現在表示中の年月を管理 初期値は今日
    @State private var displayDate: Date = Date()
    // 現在の年 displayDateから
    private var year: Int {
        Calendar.current.year(from: displayDate) ?? 20000
    }
    // 日付と瞑想時間の配列
    private var calendarDates: [CalendarInfo] {
        //
        var result = createCalendarDates(displayDate)
        while result.count < 42 {
            result.append(CalendarInfo(date: Date(), meditationTime: 0))
        }
        return result
    }
    // 曜日
    private let weekdays = Calendar.current.shortWeekdaySymbols
    // グリッドアイテム
    private let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 40, maximum: 80)), count: 7)
    // 瞑想の記録
    @State var meditationRecords: [CalendarInfo] = []
    // 日付と時間
    @State var checkDates: [Date: Int] = [:]
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景色を紺色に設定
                Color("backgroundNavy")
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(String(year))年")
                        .foregroundColor(Color(.keyWhite))
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack {
                        // 年月の表示
                        Text("\(displayDate.month)月")
                            .foregroundColor(Color(.keyWhite))
                            .bold()
                        // フォントサイズは30
                            .font(.largeTitle.bold())
                            .minimumScaleFactor(0.5)
                        Spacer(minLength: 0)
                        Button {
                            // 前月へ
                            if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: displayDate) {
                                displayDate = newDate
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .foregroundColor(Color(.keyWhite))
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                        Button {
                            if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: displayDate) {
                                displayDate = newDate
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color(.keyWhite))
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                    }
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
                            ZStack {
                                // 日付表示
                                Text("\(Calendar.current.component(.day, from: calendarDate.date))")
                                // 文字サイズ
                                    .font(.title2)
                                    .bold()
                                // 今日の日付はライム色、その他はキーホワイト
                                    .foregroundColor(Calendar.current.isDateInToday(calendarDate.date) ? Color(.dateInTodayLime) : Color(.keyWhite))
                                // サイズ
                                    .frame(minWidth: 45, minHeight: 60)
                                // 瞑想時間に応じた背景色
                                    .background(Color.backgroundColor(for: calendarDate.meditationTime))
                                // 角の丸み
                                    .cornerRadius(10)
                            } // ZStackここまで
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
                } // VStackここまで
            } // ZStackここまで
        } // geometryここまで
        .onAppear {
            // 仮の瞑想記録を代入
            meditationRecords = calendarDates
            checkDates = checkDate(from: meditationRecords)
        }
    } // bodyここまで
} // CalendarViewここまで

private func createCalendarDates(_ date: Date) -> [CalendarInfo] {
    // 瞑想時間のサンプルデータ
    let timeData = [
        // 今日
        CalendarInfo(date: Date(), meditationTime: 40),
        // 昨日
        CalendarInfo(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, meditationTime: 10),
        // 一昨日
        CalendarInfo(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, meditationTime: 60)
    ]
    // 指定月のカレンダー
    var days = [CalendarInfo]()
    // 月の初めの日付と月の日数がなければ
    guard let startDateOfMonth = Calendar.current.startDateOfMonth(from: date),
          let daysInMonth = Calendar.current.daysInMonth(from: date) else {
        // 何も返却しない
        return []
    } // guard let ここまで
    // 今月の全ての日付
    for day in 0..<daysInMonth {
        // 今月の開始日から1日ずつ加算した日付
        guard let currentDate = Calendar.current.date(byAdding: .day, value: day, to: startDateOfMonth) else {
            // 日付がなければ処理しない
            continue
        }
        // currentDateと同じ日付を探す
        let meditationTime = timeData.first(where: { record in
            // recordDate が currentDate と同じ日（年月日）か確認
            Calendar.current.isDate(record.date, inSameDayAs: currentDate)
            // なければ0
        })?.meditationTime ?? 0
        // 今月の開始日から1日ずつ加算
        days.append(CalendarInfo(date: Calendar.current.date(byAdding: .day, value: day, to: startDateOfMonth)!, meditationTime: meditationTime))
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
        days.insert(CalendarInfo(date: Date(), meditationTime: 0), at: 0)
    }
    // 最終週のオフセットを追加
    for _ in 0..<lastWeekEmptyDays {
        days.append(CalendarInfo(date: Date(), meditationTime: 0))
    }
    return days
} // createCalendarDate
/// 日付に応じた瞑想時間の設定 計算した結果を格納する
func checkDate(from records: [CalendarInfo]) -> [Date: Int] {
    let totals = Dictionary(grouping: records, by: { $0.date }).mapValues { $0.reduce(0) { $0 + $1.meditationTime } }
    return totals
}
// private func generateCalendar(for date: Date) -> [CalendarInfo] {
//     //
//     var result = createCalendarDates(displayDate)
//     while result.count < 42 {
//         result.append(CalendarInfo(date: Date(), meditationTime: 0))
//     }
//     return result
// }
#Preview {
    CalendarView()
}
