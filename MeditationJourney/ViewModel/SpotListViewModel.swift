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
    // モデルのインスタンス化
    private let spotListModel: SpotListModel = SpotListModel()
    func fetchSpotList() {
        spotList = spotListModel.spotList
    } // fetchSpotListここまで
} // SpotListViewModelここまで
