//
//  SpotListViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/28.
//

import CoreData
import SwiftUI

/// マップ上のピン留めスポットを管理するViewModel
/// CoreDataから瞑想データを取得し、60分以上瞑想した音の種類に対応するスポットにピンを表示する
class SpotListViewModel: ObservableObject {
    /// 60分以上達成した音の場所を格納するプロパティ（マップにピン表示される）
    @Published var achievedSpots: [SpotDataModel] = []
    /// CoreDataから取得した瞑想記録の配列
    var meditationRecords: [MeditationInfo] = []
    /// 全てのスポットリスト（緯度経度の情報を含む）
    private(set) var spotList: [SpotDataModel] = []
    /// スポットデータを管理するモデルのインスタンス
    private let spotListModel: SpotListModel = SpotListModel()
    /// CoreDataのコンテキスト（データベース操作に使用）
    private let context: NSManagedObjectContext
    /// 初期化メソッド
    /// - Parameter context: CoreDataのコンテキスト（デフォルトは共有インスタンス）
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    /// スポットリストを取得するメソッド
    /// SpotListModelから全てのスポットデータ（音の種類と緯度経度）を取得する
    func fetchSpotList() {
        spotList = spotListModel.spotList
    }  // fetchSpotListここまで
    /// CoreDataから瞑想記録を取得するメソッド
    /// 保存されている全ての瞑想データを日付の降順で取得し、meditationRecordsプロパティに格納する
    func loadMeditationRecords() {
        // CoreDataからMeditationInfoエンティティのデータを取得するためのリクエストを作成
        let request: NSFetchRequest<MeditationInfo> = MeditationInfo.fetchRequest()
        // 日付の降順（最新のデータが先頭）でソートする設定
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \MeditationInfo.date, ascending: false)
        ]

        do {
            // CoreDataから実際にデータを取得
            meditationRecords = try context.fetch(request)
        } catch {
            print("瞑想記録の取得に失敗しました: \(error)")
            // エラーが発生した場合は空の配列を設定
            meditationRecords = []
        }
    }
    // 60分以上達成の音の場所を計算、抽出するメソッド
    func calculateAchievedSpots() {
        // グループ化して合計時間を計算
        let totals = Dictionary(grouping: meditationRecords, by: { $0.worldSounds ?? "" })
            .mapValues { $0.reduce(0) { $0 + Int($1.meditationTime) } }
        // 60分以上のスポットのみ抽出して保持
        achievedSpots = spotList.filter {
            (totals[$0.spotName] ?? 0) >= 60
        }
    }  // func calculateAchievedSpots
}  // SpotListViewModelここまで
