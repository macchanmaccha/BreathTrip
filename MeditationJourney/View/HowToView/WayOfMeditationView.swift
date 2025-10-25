//
//  WayOfMeditationView.swift
//  MeditationJourney
//
//  Created by apple on 2024/06/26.
//

import SwiftUI

struct WayOfMeditationView: View {
    /// 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            // 背景色を紺色に設定
            Color("backgroundNavy")
                .edgesIgnoringSafeArea(.all)
        }  // ZStackここまで
        .navigationBarBackButtonHidden(true)
        // 前画面へ戻る
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .tint(Color(.keyWhite))
                }  // Buttonここまで
            }  // ToolbarItemここまで
        }
    }  // bodyここまで
}  // Viewここまで

#Preview {
    WayOfMeditationView()
}
