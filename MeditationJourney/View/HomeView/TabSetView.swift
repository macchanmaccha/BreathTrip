//
//  TabSetView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/10.
//

import CoreData
import SwiftUI

struct TabSetView: View {
    // タブの選択項目を保持
    @State private var selection: Int = 1
    // MeditatingSetViewModel
    @StateObject private var meditatingSetViewModel = MeditatingSetViewModel()
    // ListeningSetViewModel
    @StateObject private var listeningSetViewModel = ListeningSetViewModel()
    // CalendarViewModel
    @StateObject private var calendarViewModel = CalendarViewModel()
    // SpotListViewModel
    @StateObject private var spotListViewModel = SpotListViewModel()
    var body: some View {
        // タブの設定
        TabView(selection: $selection) {
            Group {
                // TabViewの要素
                // 瞑想設定画面へ遷移
                MeditationSetView(viewModel: meditatingSetViewModel)
                    .tabItem {
                        Label("瞑想", systemImage: "figure.mind.and.body")
                    }
                    .tag(1)
                // 音設定画面へ遷移
                ListeningSetView(viewModel: listeningSetViewModel)
                    .tabItem {
                        Label("音をきく", systemImage: "music.quarternote.3")
                    }
                    .tag(2)
                // カレンダー画面へ遷移
                CalendarView(viewModel: calendarViewModel)
                    .tabItem {
                        Label("カレンダー", systemImage: "calendar")
                    }
                    .tag(3)
                // マップ画面へ遷移
                MapView(viewModel: spotListViewModel)
                    .tabItem {
                        Label("地図", systemImage: "map")
                    }
                    .tag(4)
                // テスト用
                TestView()
                    .tabItem {
                        Label("テスト", systemImage: "star")
                    }
                    .tag(6)
            }
            .toolbarBackground(.backgroundNavy, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }  // TabViewここまで
    }  // bodyここまで
}  // ContentViewここまで

#Preview {
    TabSetView()
}
