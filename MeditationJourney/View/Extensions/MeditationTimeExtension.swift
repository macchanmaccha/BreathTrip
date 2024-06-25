//
//  MeditationTimeExtension.swift
//  MeditationJourney
//
//  Created by apple on 2024/06/09.
//

import SwiftUI
// 色の拡張機能
extension Color {
    static func backgroundColor(for meditationTime: Int) -> Color {
        switch meditationTime {
            // 勉強時間が1〜20分だったとき
        case 1...20:
            // firstStageBlue
            return Color(.firstStageBlue)
            // 勉強時間が21〜40分だったとき
        case 21...40:
            // secondStageBlue
            return Color(.secondStageBlue)
            // 勉強時間が41〜60分だったとき
        case 41...60:
            // thirdStageBlue
            return Color(.thirdStageBlue)
            // 勉強しなかったとき
        default:
            // デフォルトの背景色
            return Color.clear
        }
    }
}
