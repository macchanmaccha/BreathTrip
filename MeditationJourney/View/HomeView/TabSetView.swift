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
            // 瞑想設定画面へ遷移
            MeditationSetView()
                .tabItem {
                    Label("瞑想", systemImage: "figure.mind.and.body")
                }
                .tag(1)
            // 音設定画面へ遷移
            SoundSetView(viewModel: <#MeditatingSetViewModel#>, isShowSheet: <#Binding<Bool>#>, selectedContinent: <#ContinentModel#>)
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
        } // TabViewここまで
        // タブ選択時の色の設定
        .accentColor(Color(.keyWhite))
        .onAppear {
            // タブの外観を設定
            let appearance = UITabBarAppearance()
            // タブの背景を不透明にする
            appearance.configureWithOpaqueBackground()
            // 背景色をbackgroundNavyに
            appearance.backgroundColor = UIColor(Color(.backgroundNavy))
            // 非選択のタブのテキスト色を設定
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(Color(.accentGray))
            ]
            // アプリ内のタブバーの通常の状態で、 appearance外観設定を使って表示する
            UITabBar.appearance().standardAppearance = appearance
            // タブバーの背景を有効にする
            UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
        }
    } // bodyここまで
} // ContentViewここまで

struct TabSetView_Previews: PreviewProvider {
    static var previews: some View {
        TabSetView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
