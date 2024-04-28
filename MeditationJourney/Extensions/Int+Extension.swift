//
//  ExtensionsInt.swift
//  MeditationJourney
//
//  Created by apple on 2024/04/13.
//

extension Int {
    /// 分と秒の表示
    func formattedTime() -> String {
        // 60で割ったものを分数表示に
        let minutes = self / 60
        // あまりは秒数に
        let seconds = self % 60
        // 〇〇:〇〇表示でリターン
        return String(format: "%02d:%02d", minutes, seconds)
    } // func formattedTime()ここまで
}
