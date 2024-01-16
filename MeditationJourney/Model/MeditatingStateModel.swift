//
//  MeditatingStateModel.swift
//  MeditationJourney
//
//  Created by apple on 2024/01/15.
//

import Foundation

// この状態（瞑想前タイマーカウントダウン、瞑想タイマーカウントダウンなど）をenum型で作ります。
// そして、アクション（onApperやButton、タイマー終了）で状態を変更します、この状態の変更をonChangeで検知して、カウントダウンしたり、アラートを出したります。
// その画面（状態）で始めること（entry）は、状態（state）が変化したタイミングで始めます。状態の変更を基準にします。
enum MeditatingStateModel {
    case preStart  // 瞑想前タイマーカウントダウン
    case prePause  // 瞑想前タイマー中断
    case start     // 瞑想タイマーカウントダウン
    case pause     //　瞑想タイマー中断
    case end       // 瞑想終了
} // enumここまで
