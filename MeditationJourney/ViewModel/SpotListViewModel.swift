//
//  SpotPinViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/28.
//

import SwiftUI

class SpotListViewModel: ObservableObject {
    // モデルのインスタンス化
    private let spotListModel: SpotListModel = SpotListModel()
    // スポットリスト（緯度経度の情報）
    @Published var spotList: [SpotDataModel] = []
    func fetchSpotList() {
        spotList = spotListModel.spotList
    } // fetchSpotListここまで
} // SpotListViewModelここまで
