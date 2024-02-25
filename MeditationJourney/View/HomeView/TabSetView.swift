//
//  TabSetView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/10.
//

import SwiftUI
import CoreData

struct TabSetView: View {
    // タブの選択項目を保持
    @State private var selection: Int = 1
    var body: some View {
        // タブの設定
        TabView(selection: $selection) {
            Group {
                     // TabViewの要素
            // 瞑想設定画面へ遷移
            MeditationSetView()
                .tabItem {
                    Label("瞑想", systemImage: "figure.mind.and.body")
                }
                .tag(1)
            // 音設定画面へ遷移
            SoundSetView()
                .tabItem {
                    Label("音をきく", systemImage: "music.quarternote.3")
                }
                .tag(2)
            // カレンダー画面へ遷移
            CalendarView()
                .tabItem {
                    Label("カレンダー", systemImage: "calendar")
                }
                .tag(3)
            // マップ画面へ遷移
            MapView()
                .tabItem {
                    Label("地図", systemImage: "map")
                }
                .tag(4)
            // 説明画面へ遷移
            ExplanationView()
                .tabItem {
                    Label("瞑想とは", systemImage: "questionmark.circle")
                }
                .tag(5)
            }
           .toolbarBackground(Color(.backgroundNavy), for: .tabBar)
           .toolbarBackground(.visible, for: .tabBar)
           .toolbarColorScheme(.dark, for: .tabBar)
        } // TabViewここまで
    } // bodyここまで
} // ContentViewここまで

struct TabSetView_Previews: PreviewProvider {
    static var previews: some View {
        TabSetView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
