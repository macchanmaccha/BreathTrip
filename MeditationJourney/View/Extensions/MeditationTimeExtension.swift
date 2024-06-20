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
            // 勉強時間が1〜10分だったとき
        case 1...10:
            // fifthStageBlue
            return Color(.fifthStageBlue)
            // 勉強時間が11〜20分だったとき
        case 11...20:
            // secondStageBlue
            return Color(.secondStageBlue)
            // 勉強時間が21〜30分だったとき
        case 21...30:
            // thirdStageBlue
            return Color(.thirdStageBlue)
            // 勉強時間が31〜40分だったとき
        case 31...40:
            // fourthStageBlue
            return Color(.fourthStageBlue)
            // 勉強時間が41〜50分だったとき
        case 41...50:
            // fifthStageBlue
            return Color(.fifthStageBlue)
            // 勉強時間が51〜60分だったとき
        case 51...60:
            // sixthStageBlue
            return Color(.sixthStageBlue)
            // 勉強しなかったとき
        default:
            // デフォルトの背景色
            return Color.clear
        }
    }
}
