////
////  CalendarView.swift
////  MeditationJourney
////
////  Created by apple on 2023/09/17.
////
import SwiftUI

/// カレンダーの日付を表す構造体
/// 各日付の情報（日付と瞑想時間）を格納するためのデータモデル
struct CalendarInfo: Identifiable {
    // 識別子
    var id = UUID()
    // 日付（日付は必ず存在するため非オプショナル型）
    var date: Date
    // 瞑想時間
    var meditationTime: Int
} // CalendarDatesここまで

struct CalendarView: View {
    // MARK: - Properties
    // 現在表示中の年月を管理する状態変数、初期値は今日の日付
    @State private var displayDate: Date = Date()
    // 現在の年 displayDateから
    private var year: Int {
        Calendar.current.year(from: displayDate) ?? 20000
    }
    // 曜日
    private let weekdays = Calendar.current.shortWeekdaySymbols
    // カレンダーのグリッドレイアウト用の列定義、7列（曜日分）で最小40最大80の柔軟な幅
    private let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 40, maximum: 80)), count: 7)
    // 瞑想の記録
    @State var meditationRecords: [CalendarInfo] = []
    // 日付と瞑想時間の合計を格納する辞書、キーは日付、値は合計時間
    @State var checkDates: [Date: Int] = [:]
    // MARK: - Body
    // SwiftUIのViewの本体、UIの構造を定義
    var body: some View {
        // 画面のサイズ情報を取得するためのGeometryReader
        GeometryReader { geometry in
            ZStack {
                // 背景色を紺色に設定し、セーフエリアを無視して全画面に適用
                Color("backgroundNavy")
                    .edgesIgnoringSafeArea(.all)
                // 縦方向に要素を配置するVStack、左寄せで10ポイントの間隔
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
                            // フォントサイズは30、画面に合わせて縮小可能
                            .font(.largeTitle.bold())
                            .minimumScaleFactor(0.5)
                        // 右側の要素を右端に押し込むためのスペーサー
                        Spacer(minLength: 0)
                        // 前月に移動するボタン
                        Button {
                            // 前月の日付を計算してdisplayDateを更新
                            if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: displayDate) {
                                displayDate = newDate
                            }
                        } label: {
                            // 左向きの矢印アイコンを表示
                            Image(systemName: "chevron.left")
                        }
                        .foregroundColor(Color(.keyWhite))
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                        // 翌月に移動するボタン
                        Button {
                            // 翌月の日付を計算してdisplayDateを更新
                            if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: displayDate) {
                                displayDate = newDate
                            }
                        } label: {
                            // 右向きの矢印アイコンを表示
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color(.keyWhite))
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                    }
                    // 曜日ヘッダーを表示するグリッド
                    LazyVGrid(columns: columns) {
                        // 曜日の配列をループして各曜日を表示
                        ForEach(weekdays, id: \.self) { weekday in
                            // 各曜日のテキスト表示
                            Text(weekday)
                                .foregroundColor(Color(.keyWhite))
                                .lineLimit(1)
                            // 文字サイズ
                                .font(.headline)
                                .bold()
                            // フレーム
                                .frame(minWidth: 45, minHeight: 45)
                        } // ForEach（曜日ループ）終了
                    } // LazyVGrid（曜日ヘッダー）終了
                    // カレンダーの日付セルを表示するグリッド
                    // 画面の高さの3%を間隔として設定
                    LazyVGrid(columns: columns, spacing: geometry.size.height * 0.03) {
                        // カレンダー日付の配列をループして各日付セルを表示
                        // getCalendarDates()には今月以外（前月・翌月）のダミー日付も含まれる
                        ForEach(getCalendarDates()) { calendarDate in
                            // このセルの日付が「表示中の月」と同じかどうかを判定
                            if Calendar.current.component(.month, from: calendarDate.date) == Calendar.current.component(.month, from: displayDate) {
                                // 今月の日付なら日付を表示
                                Text("\(Calendar.current.component(.day, from: calendarDate.date))")
                                    .font(.title2)
                                    .bold()
                                    // 今日ならライム色、それ以外は白色で表示
                                    .foregroundColor(Calendar.current.isDateInToday(calendarDate.date) ? Color(.dateInTodayLime) : Color(.keyWhite))
                                    .frame(minWidth: 45, minHeight: 60)
                                    // 瞑想時間に応じた背景色を設定
                                    .background(Color.backgroundColor(for: calendarDate.meditationTime))
                                    .cornerRadius(10)
                            } else {
                                // 今月以外（前月・翌月のダミー日付）は空白を表示
                                // ただし背景色は瞑想時間に応じて設定
                                Color.backgroundColor(for: calendarDate.meditationTime)
                                    .frame(minWidth: 45, minHeight: 60)
                                    .cornerRadius(10)
                            }
                        } // ForEach（日付セルループ）終了
                    } // LazyVGrid（日付グリッド）終了
                    // 色の説明　LessからMoreまでを表示
                    HStack {
                        // 右寄せ
                        Spacer()
                        Text("Less")
                            .foregroundColor(Color(.keyWhite))
                        
                        // 瞑想時間0分の色サンプル（透明）
                        Rectangle()
                            .border(.gray, width: 1.5)
                            .frame(maxWidth: 20, maxHeight: 25 )
                            .foregroundColor(.clear)
                            .cornerRadius(4)
                        
                        // 瞑想時間1-20分の色サンプル（第1段階ブルー）
                        Rectangle()
                            .border(.gray, width: 1.5)
                            .frame(maxWidth: 20, maxHeight: 25 )
                            .foregroundColor(Color(.firstStageBlue))
                            .cornerRadius(4)
                        
                        // 瞑想時間21-40分の色サンプル（第2段階ブルー）
                        Rectangle()
                            .border(.gray, width: 1.5)
                            .frame(maxWidth: 20, maxHeight: 25 )
                            .foregroundColor(Color(.secondStageBlue))
                            .cornerRadius(4)
                        
                        // 瞑想時間41分以上の色サンプル（第3段階ブルー）
                        Rectangle()
                            .border(.gray, width: 1.5)
                            .frame(maxWidth: 20, maxHeight: 25 )
                            .foregroundColor(Color(.thirdStageBlue))
                            .cornerRadius(4)
                        Text("More")
                            .foregroundColor(Color(.keyWhite))
                    } // HStack（色の説明）終了
                } // VStack（メインコンテンツ）終了
            } // ZStack（レイヤー構造）終了
        } // GeometryReader（画面サイズ取得）終了
        
        // Viewが表示される時に実行される処理
        .onAppear {
            // 仮の瞑想記録を代入してカレンダーに表示
            meditationRecords = getCalendarDates()
            // 日付ごとの瞑想時間合計を計算して辞書に格納
            checkDates = checkDate(from: meditationRecords)
        }
    } // body（View本体）終了
    // MARK: - Private Methods
    // 日付と瞑想時間の配列を取得するメソッド
    // カレンダー表示用の完全な日付配列（42日分）を生成
    private func getCalendarDates() -> [CalendarInfo] {
        // 指定月のカレンダー日付を生成
        var result = createCalendarDates(displayDate)
        // カレンダーグリッドを6週間（42日）で統一するため、不足分をダミーで補完
        while result.count < 42 {
            result.append(CalendarInfo(date: Date(), meditationTime: 0))
        }
        return result
    }
    // 指定月のカレンダー日付配列を生成するメソッド
    // 前月・翌月のオフセット日付も含めて完全なカレンダーグリッドを作成
    private func createCalendarDates(_ date: Date) -> [CalendarInfo] {
        // 瞑想時間のサンプルデータ（実際のアプリではデータベースから取得）
        let timeData = [
            // 今日の瞑想時間（40分）
            CalendarInfo(date: Date(), meditationTime: 40),
            // 昨日の瞑想時間（10分）
            CalendarInfo(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, meditationTime: 10),
            // 一昨日の瞑想時間（60分）
            CalendarInfo(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, meditationTime: 60)
        ]
        // 指定月のカレンダー日付を格納する配列
        var days = [CalendarInfo]()
        // 月の初めの日付と月の日数を取得、取得できない場合は空配列を返す
        guard let startDateOfMonth = Calendar.current.startDateOfMonth(from: date),
              let daysInMonth = Calendar.current.daysInMonth(from: date) else {
            // 何も返却しない
            return []
        } // guard let（月の開始日と日数取得）終了
        // 今月の全ての日付をループして処理
        for day in 0..<daysInMonth {
            // 今月の開始日から1日ずつ加算した日付を計算
            guard let currentDate = Calendar.current.date(byAdding: .day, value: day, to: startDateOfMonth) else {
                // 日付が計算できない場合は処理をスキップ
                continue
            }
            // サンプルデータからcurrentDateと同じ日付の瞑想時間を検索
            let meditationTime = timeData.first(where: { record in
                // recordDate が currentDate と同じ日（年月日）か確認
                Calendar.current.isDate(record.date, inSameDayAs: currentDate)
                // 見つからない場合は0分を設定
            })?.meditationTime ?? 0
            
            // 今月の開始日から1日ずつ加算した日付と瞑想時間を配列に追加
            days.append(CalendarInfo(date: Calendar.current.date(byAdding: .day, value: day, to: startDateOfMonth)!, meditationTime: meditationTime))
        } // for day in（今月の日付ループ）終了
        // 最初と最後の日付を取得して週のオフセットを計算
        // 最初の日と最後の日を取得
        guard let firstDay = days.first?.date, let lastDay = days.last?.date,
              // 最初の日の曜日を取得（1=日曜日、2=月曜日、...、7=土曜日）
              let firstDateWeekday = Calendar.current.weekday(from: firstDay),
              // 最後の日の曜日を取得
              let lastDateWeekday = Calendar.current.weekday(from: lastDay) else {
            // 取得できない場合は空配列を返す
            return []
        } // guard let（最初と最後の日付取得）終了
        // 初週のオフセット日数を計算（月の開始日が何曜日かによって前月の日付を何日分表示するか）
        let firstWeekEmptyDays = firstDateWeekday - 1
        // 最終週のオフセット日数を計算（月の最終日が何曜日かによって翌月の日付を何日分表示するか）
        let lastWeekEmptyDays = 7 - lastDateWeekday
        // 初週のオフセットを配列の先頭に追加（前月の日付）
        for _ in 0..<firstWeekEmptyDays {
            days.insert(CalendarInfo(date: Date(), meditationTime: 0), at: 0)
        }
        // 最終週のオフセットを配列の末尾に追加（翌月の日付）
        for _ in 0..<lastWeekEmptyDays {
            days.append(CalendarInfo(date: Date(), meditationTime: 0))
        }
        return days
    } // createCalendarDatesメソッド終了
} // CalendarView構造体終了
// MARK: - Helper Functions
/// 日付に応じた瞑想時間の設定 計算した結果を格納する
/// 同じ日付の複数の瞑想記録がある場合、時間を合計して返す
func checkDate(from records: [CalendarInfo]) -> [Date: Int] {
    // 日付でグループ化して、同じ日付の瞑想時間を合計
    let totals = Dictionary(grouping: records, by: { $0.date }).mapValues { $0.reduce(0) { $0 + $1.meditationTime } }
    return totals
}

#Preview {
    CalendarView()
}