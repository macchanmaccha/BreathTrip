//
//  Untitled.swift
//  MeditationJourney
//
//  Created by apple on 2025/05/11.
//

import Foundation

// 瞑想の情報
struct MeditationInfo: Identifiable {
    let id = UUID()
    // 日付
    let date: Date
    // 世界遺産
    let worldHeritage: String
    // 時間
    let meditationTime: Int
}
