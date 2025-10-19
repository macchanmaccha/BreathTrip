//
//  SpotPinViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/28.
//

import CoreData
import SwiftUI

class SpotListViewModel: ObservableObject {
    // 60分以上達成の音の場所を格納するプロパティ
    @Published var achievedSpots: [SpotDataModel] = []
    // 瞑想の記録
    var meditationRecords: [MeditationInfo] = []
    // スポットリスト（緯度経度の情報）
    private(set) var spotList: [SpotDataModel] = []
    // モデルのインスタンス化
    private let spotListModel: SpotListModel = SpotListModel()
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    func fetchSpotList() {
        spotList = spotListModel.spotList
    }  // fetchSpotListここまで
    func loadMeditationInfo() {
        // contextの中にnewMeditationInfoというデータを作る
        let newMeditationInfo = MeditationInfo(context: context)
        // 日付
        newMeditationInfo.date = Date()
    }
    // 60分以上達成の音の場所を計算、抽出するメソッド
    func calculateAchievedSpots() {
        // グループ化して合計時間を計算
        let totals = Dictionary(grouping: meditationRecords, by: { $0.worldSounds })
            .mapValues { $0.reduce(0) { $0 + $1.meditationTime } }
        // 60分以上のスポットのみ抽出して保持
        achievedSpots = spotList.filter {
            (totals[$0.spotName] ?? 0) >= 60
        }
    }  // func calculateAchievedSpots
}  // SpotListViewModelここまで
