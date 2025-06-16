//
//  MapView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI
import MapKit

struct MapView: View {
    // viewModelのインスタンス化
    @StateObject var viewModel: SpotListViewModel = SpotListViewModel()
    // マップの中心の情報、緯度経度、範囲
    @State private var region: MapCameraPosition = .region(MKCoordinateRegion(
        center: .init(latitude: 35.682839, longitude: 139.759455),
        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
    ))
    var body: some View {
        VStack {
            // 地図の表示およびマーカーの表示
            Map(position: $region) {
                ForEach(viewModel.worldHeritageSpots, id: \.id) { spot in
                    Marker(spot.spotName, coordinate: spot.coordinate)
                } // ForEach
//                ForEach(viewModel.spotList, id: \.id) { spot in
//                    Marker(spot.spotName, coordinate: spot.coordinate)
//                } // ForEach
            } // Map
            // ダークモード
            .colorScheme(.dark)
        } // VStack
        .onAppear {
            viewModel.fetchSpotList()
            viewModel.meditationRecords = [
                MeditationInfo(date: Date(), worldHeritage: "白神山地", meditationTime: 30),
                MeditationInfo(date: Date(), worldHeritage: "ナイアガラの滝", meditationTime: 35),
                // 明日のデータ
                MeditationInfo(date: Date()-1, worldHeritage: "万里の長城", meditationTime: 40),
                MeditationInfo(date: Date(), worldHeritage: "白神山地", meditationTime: 30),
                MeditationInfo(date: Date()-30, worldHeritage: "モン・サン・ミシェル", meditationTime: 30),
                MeditationInfo(date: Date(), worldHeritage: "モン・サン・ミシェル", meditationTime: 30),
                MeditationInfo(date: Date()+40, worldHeritage: "白神山地", meditationTime: 30),
                MeditationInfo(date: Date(), worldHeritage: "モン・サン・ミシェル", meditationTime: 30),
                MeditationInfo(date: Date(), worldHeritage: "ナイアガラの滝", meditationTime: 30)
            ]
        } // .onAppearここまで
    } // bodyここまで
} // Mapここまで
#Preview {
    MapView()
}
