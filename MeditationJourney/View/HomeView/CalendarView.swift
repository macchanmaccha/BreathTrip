////
////  CalendarView.swift
////  MeditationJourney
////
////  Created by apple on 2023/09/17.
////
import SwiftUI

/// 色の説明用のボックス
struct LegendBox: View {
    let color: Color

    var body: some View {
        Rectangle()
            .border(.gray, width: 1.5)
            .frame(maxWidth: 20, maxHeight: 25)
            .foregroundColor(color)
            .cornerRadius(4)
    }
}

struct CalendarView: View {
    // MARK: - Properties
    // viewModel
    @StateObject var viewModel: CalendarViewModel = CalendarViewModel()
    // 曜日
    private let weekdays = Calendar.current.shortWeekdaySymbols
    // カレンダーのグリッドレイアウト用の列定義、7列（曜日分）で最小40最大80の柔軟な幅
    private let columns: [GridItem] = Array(
        repeating: .init(.flexible(minimum: 40, maximum: 80)), count: 7)
    // MARK: - Body
    // SwiftUIのViewの本体、UIの構造を定義
    var body: some View {
        // 画面のサイズ情報を取得するためのGeometryReader
        GeometryReader { geometry in
            ZStack {
                // 背景色を紺色に設定し、セーフエリアを無視して全画面に適用
                Color.backgroundNavy
                    .edgesIgnoringSafeArea(.all)
                // 縦方向に要素を配置するVStack、左寄せで10ポイントの間隔
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(String(viewModel.displayDate.year))年")
                        .foregroundStyle(.keyWhite)
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack {
                        // 年月の表示
                        Text("\(viewModel.displayDate.month)月")
                            .foregroundStyle(.keyWhite)
                            .bold()
                            // フォントサイズは30、画面に合わせて縮小可能
                            .font(.largeTitle.bold())
                            .minimumScaleFactor(0.5)
                        // 右側の要素を右端に押し込むためのスペーサー
                        Spacer(minLength: 0)
                        // 前月に移動するボタン
                        Button {
                            // 前月の日付を計算してdisplayDateを更新
                            if let newDate = Calendar.current.date(
                                byAdding: .month, value: -1, to: viewModel.displayDate) {
                                viewModel.displayDate = newDate
                            }
                        } label: {
                            // 左向きの矢印アイコンを表示
                            Image(systemName: "chevron.left")
                        }
                        .foregroundStyle(.keyWhite)
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                        // 翌月に移動するボタン
                        Button {
                            // 翌月の日付を計算してdisplayDateを更新
                            if let newDate = Calendar.current.date(
                                byAdding: .month, value: 1, to: viewModel.displayDate) {
                                viewModel.displayDate = newDate
                            }
                        } label: {
                            // 右向きの矢印アイコンを表示
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.keyWhite)
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                    }
                    // 曜日ヘッダーを表示するグリッド
                    LazyVGrid(columns: columns) {
                        // 曜日の配列をループして各曜日を表示
                        ForEach(weekdays, id: \.self) { weekday in
                            // 各曜日のテキスト表示
                            Text(weekday)
                                .foregroundStyle(.keyWhite)
                                .lineLimit(1)
                                // 文字サイズ
                                .font(.headline)
                                .bold()
                                // フレーム
                                .frame(minWidth: 45, minHeight: 45)
                        }  // ForEach（曜日ループ）終了
                    }  // LazyVGrid（曜日ヘッダー）終了
                    // カレンダーの日付セルを表示するグリッド
                    // 画面の高さの3%を間隔として設定
                    LazyVGrid(columns: columns, spacing: geometry.size.height * 0.03) {
                        // カレンダー日付の配列をループして各日付セルを表示
                        // getCalendarDates()には今月以外（前月・翌月）のダミー日付も含まれる
                        ForEach(viewModel.getCalendarDates()) { calendarDate in
                            // このセルの日付が「表示中の月」と同じかどうかを判定
                            if Calendar.current.component(.month, from: calendarDate.date)
                                == Calendar.current.component(.month, from: viewModel.displayDate) {
                                // 今月の日付なら日付を表示
                                Text("\(Calendar.current.component(.day, from: calendarDate.date))")
                                    .font(.title2)
                                    .bold()
                                    // 今日ならライム色、それ以外は白色で表示
                                    .foregroundStyle(
                                        Calendar.current.isDateInToday(calendarDate.date)
                                            ? .dateInTodayLime : .keyWhite
                                    )
                                    .frame(minWidth: 45, minHeight: 60)
                                    // 瞑想時間に応じた背景色を設定
                                    .background(
                                        Color.backgroundStyle(for: calendarDate.meditationTime)
                                    )
                                    .cornerRadius(10)
                            } else {
                                // 今月以外（前月・翌月のダミー日付）は空白を表示
                                // EmptyView()ではなく透明なRectangleを使用
                                // これにより、グリッドのセルとして正しく認識される
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(minWidth: 45, minHeight: 60)
                            }
                        }  // ForEach（日付セルループ）終了
                    }  // LazyVGrid（日付グリッド）終了
                    // 色の説明　LessからMoreまでを表示
                    HStack {
                        // 右寄せ
                        Spacer()
                        Text("Low")
                            .foregroundColor(.keyWhite)
                        // 瞑想時間0分の色サンプル（透明）
                        LegendBox(color: .clear)
                        // 瞑想時間1-20分の色サンプル（第1段階ブルー）
                        LegendBox(color: .firstStageBlue)
                        // 瞑想時間21-40分の色サンプル（第2段階ブルー）
                        LegendBox(color: .secondStageBlue)
                        // 瞑想時間41分以上の色サンプル（第3段階ブルー）
                        LegendBox(color: .thirdStageBlue)
                        Text("High")
                            .foregroundColor(.keyWhite)
                    }  // HStack（色の説明）終了
                }  // VStack（メインコンテンツ）終了
                .padding(20)
            }  // ZStack（レイヤー構造）終了
        }  // GeometryReader（画面サイズ取得）終了
        // Viewが表示される時に実行される処理
        .onAppear {
            // 仮の瞑想記録を代入してカレンダーに表示
            viewModel.meditationRecords = viewModel.getCalendarDates()
            // 日付ごとの瞑想時間合計を計算して辞書に格納
            viewModel.checkDates = viewModel.checkDate(from: viewModel.meditationRecords)
        }
    }  // body（View本体）終了
}  // CalendarView構造体終了

#Preview {
    CalendarView()
}
