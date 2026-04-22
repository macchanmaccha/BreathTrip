//
//  MeditationAudioGuide.swift
//  MeditationJourney
//
//  呼吸瞑想の音声ガイド再生タイミング（残り秒）を管理。
//

import Foundation

enum MeditationAudioGuide {
    /// 瞑想中の中盤ガイド再生しきい値。`remainingSeconds` が各値になったタイミングで一度だけ再生。
    static func midCueSecondsRemaining(forMinutes minutes: Int) -> [TimeInterval] {
        switch minutes {
        case 1:
            return [59, 30]
        case 3:
            return [179, 120]
        case 5:
            return [299, 180, 120]
        case 10:
            return [599, 500, 300, 180]
        case 20:
            return [1199, 1000, 700, 400, 100]
        case 30:
            return [1499, 1300, 1100, 900, 600, 300]
        case 40:
            return [1999, 1800, 1600, 1300, 1000, 700, 400]
        case 50:
            return [2499, 2300, 2000, 1700, 1400, 1100, 800, 500]
        case 60:
            return [2999, 2900, 2500, 2100, 1700, 1300, 900, 500]
        default:
            return []
        }
    }
}
