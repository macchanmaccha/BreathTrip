//
//  SpotPinViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/28.
//

import SwiftUI

class SpotListViewModel: ObservableObject {
    // スポットリスト（緯度経度の情報）
    @Published private(set) var spotList: [SpotDataModel] = []
    // 瞑想の記録
    @Published var meditationRecords: [MeditationInfo] = []
    // 60分以上達成の音の場所を格納するプロパティ
    @Published var achievedSpots: [SpotDataModel] = []
    // モデルのインスタンス化
    private let spotListModel: SpotListModel = SpotListModel()
    func fetchSpotList() {
        spotList = spotListModel.spotList
    } // fetchSpotListここまで
    // 60分以上達成の音の場所を計算、抽出するメソッド
    func calculateAchievedSpots() {
        // グループ化して合計時間を計算
        let totals = Dictionary(grouping: meditationRecords, by: { $0.worldSounds })
            .mapValues { $0.reduce(0) { $0 + $1.meditationTime } }
        // 60分以上のスポットのみ抽出して保持
        achievedSpots = spotList.filter { spot in
            if let total = totals[spot.spotName], total >= 60 {
                return true
            }
            return false
        }
    } // func calculateAchievedSpots
} // SpotListViewModelここまで
