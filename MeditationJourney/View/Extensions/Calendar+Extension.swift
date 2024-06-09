//
//  Calendar+Extension.swift
//  MeditationJourney
//
//  Created by apple on 2024/06/09.
//

import Foundation

// カレンダーの拡張機能
extension Calendar {
    /// 今月の開始日を取得する
    /// - Parameter date: 対象日
    /// - Returns: 開始日
    func startOfMonth(for date: Date) -> Date? {
        // 年月の構成要素
        let comps = dateComponents([.month, .year], from: date)
        // 構成要素から日付を返却
        return self.date(from: comps)
    } // func startOfMonth
    /// 今月の日数を取得する
    /// - Parameter date: 対象日
    /// - Returns: 日数
    func daysInMonth(for date: Date) -> Int? {
        // 月の日数の返却
        return range(of: .day, in: .month, for: date)?.count
    }
    /// 今月の週数を取得する
    /// - Parameter date: 対象日
    /// - Returns: 週数
    func weeksInMonth(for date: Date) -> Int? {
        // 週数の返却
        return range(of: .weekOfMonth, in: .month, for: date)?.count
    }
    /// 対象日の年の取得
    /// - Parameter date: 対象日
    /// - Returns: 年
    func year(for date: Date) -> Int? {
        // 年の構成要素
        let comps = dateComponents([.year], from: date)
        // 年の返却
        return comps.year
    }
    /// 対象日の月の取得
    /// - Parameter date: 対象日
    /// - Returns: 月
    func month(for date: Date) -> Int? {
        // 月の構成要素
        let comps = dateComponents([.month], from: date)
        // 月の返却
        return comps.month
    }
    /// 対象日の日の取得
    /// - Parameter date: 対象日
    /// - Returns: 日
    func day(for date: Date) -> Int? {
        // 日の構成要素
        let comps = dateComponents([.day], from: date)
        // 日の返却
        return comps.day
    }
    /// 対象日の曜日の取得
    /// - Parameter date: 対象日
    /// - Returns: 曜日
    func weekday(for date: Date) -> Int? {
        // 曜日の構成要素
        let comps = dateComponents([.weekday], from: date)
        // 曜日の返却
        return comps.weekday
    }
}
