//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import SwiftUI

struct MeditatingView: View {
    // 開始前タイマー初期値5、4、3、2、1、スタート
    @State private var preparationCountDown = 5
    // タイマー
    @State private var timerHandler: Timer?
    // カウントの変数
    @State var count: Int = 0
    // 永続化する秒数設定
    @AppStorage("timer_Value") var timerValue = 10
    // 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) var dismiss
    var body: some View {
            VStack {
                Text("\(preparationCountDown)")
                    .font(.headline)
                Text("")
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
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // タイマーの設定
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if preparationCountDown > 0 {
                    preparationCountDown -= 1
                } else {
                    timer.invalidate()
                }
            }
        }
    } // bodyここまで
} // ContentViewここまで

struct MeditatingView_Previews: PreviewProvider {
    static var previews: some View {
        MeditatingView()
    }
}
