//
//  Calendar+Extension.swift
//  MeditationJourney
//
//  Created by apple on 2024/06/09.
//

import Foundation

// Dateの拡張機能

extension Date {
    /// 今月の開始日を取得する
    /// - Returns: 開始日。
    func startOfMonth() -> Date? {
        // カレンダーの取得
        let calendar = Calendar.current
        // 年月の構成要素
        let components = calendar.dateComponents([.month, .year], from: self)
        // 構成要素から日付を返却
        return calendar.date(from: components)
    }
    /// 今月の日数を取得する
    /// - Returns: 日数。
    func daysInMonth() -> Int? {
        // 月の日数の返却
        return Calendar.current.range(of: .day, in: .month, for: self)?.count
    }
    /// 今月の週数を取得する
    /// - Returns: 週数。
    func weeksInMonth() -> Int? {
        // 週数の返却
        return Calendar.current.range(of: .weekOfMonth, in: .month, for: self)?.count
    }
    /// 対象日の年の取得
    /// - Returns: 年。
    func year() -> Int? {
        // 年の構成要素
        let components = Calendar.current.dateComponents([.year], from: self)
        // 年の返却
        return components.year
    }
    /// 対象日の月の取得
    /// - Returns: 月。
    func month() -> Int? {
        // 月の構成要素
        let components = Calendar.current.dateComponents([.month], from: self)
        // 月の返却
        return components.month
    }
    /// 対象日の日の取得
    /// - Returns: 日。
    func day() -> Int? {
        // 日の構成要素
        let components = Calendar.current.dateComponents([.day], from: self)
        // 日の返却
        return components.day
    }
    /// 対象日の曜日の取得
    /// - Returns: 曜日。
    func weekday() -> Int? {
        // 曜日の構成要素
        let components = Calendar.current.dateComponents([.weekday], from: self)
        // 曜日の返却
        return components.weekday
    }
}
