//
//  MeditationAudioGuide.swift
//  MeditationJourney
//
//  呼吸瞑想の音声ガイド文言（読み上げ用）と、分数ごとの中盤ガイドスケジュール。
//

import Foundation

enum MeditationAudioGuide {
    /// preStart（瞑想開始前カウントダウン）で読み上げる姿勢のガイド
    static let postureText = "背筋を軽く伸ばし、肩の力を抜きましょう。"

    /// 瞑想終了直前（残り10秒以内で一度だけ）に読み上げる締めのガイド（全分数共通）
    static let closingText = "ゆっくりと呼吸を整え、ゆっくりと目を開けましょう。"

    /// 瞑想中のガイド。`remainingSeconds` が各しきい値以下になったタイミングで一度だけ再生する。
    static func midSessionCuesAndPhrases(forMinutes minutes: Int) -> [(remainingSeconds: TimeInterval, text: String)] {
        let thresholds = midCueSecondsRemaining(forMinutes: minutes)
        let phrases = midPhrases(forCount: thresholds.count)
        return zip(thresholds, phrases).map { (remainingSeconds: $0.0, text: $0.1) }
    }

    private static func midCueSecondsRemaining(forMinutes minutes: Int) -> [TimeInterval] {
        switch minutes {
        case 1:
            return [30]
        case 3:
            return [120, 60]
        case 5:
            return [180, 120, 60]
        case 10:
            return [420, 300, 180, 60]
        case 20:
            return [900, 600, 300, 60]
        case 30:
            return [1200, 900, 600, 300, 60]
        case 40:
            return [1500, 1200, 900, 600, 300, 60]
        case 50:
            return [1800, 1500, 1200, 900, 600, 300, 60]
        case 60:
            return [2400, 1800, 1500, 1200, 900, 600, 300, 60]
        default:
            return []
        }
    }

    private static func midPhrases(forCount count: Int) -> [String] {
        let pool = [
            "鼻からゆっくり吸い、口から静かに吐きましょう。",
            "呼吸に意識を向けましょう。雑念が浮かんでも、そっと呼吸に戻します。",
            "肩と顎の力を抜き、呼吸のリズムに合わせましょう。",
            "楽に吸って、楽に吐く。焦らず、自分のペースで。",
            "お腹にそっと意識を向け、呼吸の動きを感じてみましょう。",
            "吸うときは自然に、吐くときは少し長めに。心地よいテンポで。",
            "体のどこかに力が入っていたら、吐く息と一緒に抜いていきましょう。",
            "今ここにある呼吸だけに、そっと注意を向けます。"
        ]
        return (0..<count).map { pool[$0 % pool.count] }
    }
}
