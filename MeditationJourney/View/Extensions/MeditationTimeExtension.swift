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
            //  透明度0.1の青色
            return Color(red: 0.7, green: 0.7, blue: 1.0)
            // 勉強時間が11〜20分だったとき
        case 11...20:
            //  透明度0.2の青色
            return Color(red: 0.55, green: 0.55, blue: 1.0)
            // 勉強時間が21〜30分だったとき
        case 21...30:
            //  透明度0.4の青色
            return Color(red: 0.4, green: 0.4, blue: 1.0)
            // 勉強時間が31〜40分だったとき
        case 31...40:
            // 透明度0.6の青色
            return Color(red: 0.25, green: 0.25, blue: 1.0)
            // 勉強時間が41〜50分だったとき
        case 41...50:
            // 透明度0.8の青色
            return Color(red: 0.1, green: 0.1, blue: 1.0)
            // 勉強時間が51〜60分だったとき
        case 51...60:
            // 青色
            return Color(red: 0.0, green: 0.0, blue: 1.0)
            // 勉強しなかったとき
        default:
            // デフォルトの背景色
            return Color.clear
        }
    }
}
