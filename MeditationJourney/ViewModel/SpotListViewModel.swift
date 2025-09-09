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
    func fetchSpotList() {
        spotList = spotListModel.spotList
    }  // fetchSpotListここまで
    func loadMeditationInfo(viewContext: NSManagedObjectContext) {
        // contextの中にnewMeditationInfoというデータを作る
        let newMeditationInfo = MeditationInfo(context: viewContext)
        // 日付
        newMeditationInfo.date = Date()
    }
//    // 瞑想のデータを抽出するメソッド
//    func loadMeditationRecords() {
//        meditationRecords = [
//            MeditationInfo(date: Date(), worldSounds: "白神山地", meditationTime: 30),
//            MeditationInfo(date: Date(), worldSounds: "ナイアガラの滝", meditationTime: 10),
//            MeditationInfo(
//                date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
//                worldSounds: "万里の長城", meditationTime: 40),
//            MeditationInfo(date: Date(), worldSounds: "白神山地", meditationTime: 30),
//            MeditationInfo(
//                date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
//                worldSounds: "モン・サン・ミシェル", meditationTime: 30),
//            MeditationInfo(date: Date(), worldSounds: "モン・サン・ミシェル", meditationTime: 30),
//            MeditationInfo(
//                date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
//                worldSounds: "白神山地", meditationTime: 30),
//            MeditationInfo(date: Date(), worldSounds: "モン・サン・ミシェル", meditationTime: 30),
//            MeditationInfo(date: Date(), worldSounds: "ナイアガラの滝", meditationTime: 30),
//            MeditationInfo(
//                date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
//                worldSounds: "万里の長城", meditationTime: 40),
//        ]
//    }
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
