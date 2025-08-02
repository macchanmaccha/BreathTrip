//
//  MeditationTimeExtension.swift
//  MeditationJourney
//
//  Created by apple on 2024/06/09.
//

import SwiftUI

// 色の拡張機能
extension Color {
    /// 瞑想時間に応じた背景色を返す
    /// - Parameter meditationTime: 瞑想時間（分）
    /// - Returns: 瞑想時間に応じた背景色
    static func backgroundStyle(for meditationTime: Int) -> Color {
        switch meditationTime {
        // 瞑想時間が1〜20分だったとき
        case 1...20:
            // firstStageBlue
            return .firstStageBlue
        // 瞑想時間が21〜40分だったとき
        case 21...40:
            // secondStageBlue
            return .secondStageBlue
        // 瞑想時間が41〜60分だったとき
        case 41...60:
            // thirdStageBlue
            return .thirdStageBlue
        // 瞑想しなかったとき
        default:
            // デフォルトの背景色
            return Color.clear
        }
    }
}
