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
            return [179, 120, 60]
        case 5:
            return [299, 180, 120, 60]
        case 10:
            return [599, 420, 300, 180, 60]
        case 20:
            return [1199, 900, 600, 300, 60]
        case 30:
            return [1499, 1200, 900, 600, 300, 60]
        case 40:
            return [1999, 1500, 1200, 900, 600, 300, 60]
        case 50:
            return [2499, 1800, 1500, 1200, 900, 600, 300, 60]
        case 60:
            return [2999, 2400, 1800, 1200, 900, 600, 300, 60]
        default:
            return []
        }
    }
}
