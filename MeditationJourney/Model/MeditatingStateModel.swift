//
//  MeditatingStateModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/01/15.
//

import Foundation

enum MeditatingStateModel {
    case preStart  // 瞑想前タイマーカウントダウン
    case prePause  // 瞑想前タイマー中断
    case start     // 瞑想タイマーカウントダウン
    case pause     // 瞑想タイマー中断
    case end       // 瞑想終了
} // enumここまで
