//
//  Untitled.swift
//  MeditationJourney
//
//  Created by apple on 2025/04/08.
//

import SwiftUI

struct MeditationInfo: Identifiable {
    let id = UUID()
    let date: Date
    let country: String
    let minutes: Int
}

extension Date {
    // 月日だけを返すプロパティを追加する
    var formattedMonthDay: String {
        return Self.monthDayFormatter.string(from: self)
    }
    // staticで一度だけ作るDateFormatter
    // 月と日だけを表示する（実装では関係ないかも・・・）
    private static let monthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        return formatter
    }()
}

struct ContentView: View {
    // 国を選ぶPickerの初期値
    @State private var selectedCountry = "日本"
    // 時間選択のPickerの初期値
    @State private var selectedDuration = 10
    // recordsの配列
    @State private var records: [MeditationInfo] = []
    // 国
    let countries = ["日本", "アメリカ"]
    // 時間
    let minutesOptions: [Int] = [1, 3, 5, 10, 20, 30, 40, 50, 60]
    var body: some View {
        NavigationView {
            VStack {
                // 国の選択
                Picker("国を選択", selection: $selectedCountry) {
                    ForEach(countries, id: \.self) { country in
                        Text(country)
                    } // ForEach
                } // Picker
                .pickerStyle(MenuPickerStyle())
                // 時間の選択
                Picker("時間を選択", selection: $selectedDuration) {
                    ForEach(minutesOptions, id: \.self) { minutes in
                        Text("\(minutes)分")
                    } // ForEachここまで
                } // Pickerここまで
                // 記録するボタン
                Button("記録する") {
                    let newRecord = MeditationInfo(date: Date(), country: selectedCountry, minutes: selectedDuration)
                    records.append(newRecord)
                } // Button
                .padding()
                // 記録したものをリストで表示
                List {
                    ForEach(records, id: \.id) { record in
                        // recordsをテキスト表示
                        Text("date: \(record.date.formattedMonthDay),\ncountry: \(record.country),\nminutes: \(record.minutes)")
                    }
                } // List
            } // VStack
        } // NavigationView
    } // body
} // ContentView

#Preview {
    ContentView()
}
