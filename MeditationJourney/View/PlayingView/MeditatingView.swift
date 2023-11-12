//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import SwiftUI

struct MeditatingView: View {
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    dismiss()
                }) {
                    Text("中断する")
                        .tint(.backgroundNavy)
                        .font(.title)
                }
                .padding()
                .background(Color.keyWhite)
                .frame(width: 150, height: 100)
            } // VStackここまで
        } // NavigationStackここまで
        .navigationBarBackButtonHidden(true)
    } // bodyここまで
} // ContentViewここまで

struct MeditatingView_Previews: PreviewProvider {
    static var previews: some View {
        MeditatingView()
    }
}
