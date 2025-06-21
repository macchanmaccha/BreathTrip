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
                ForEach(viewModel.achievedSpots, id: \.id) { spot in
                    Marker(spot.spotName, coordinate: spot.coordinate)
                } // ForEach
            } // Map
            // ダークモード
            .colorScheme(.dark)
        } // VStack
        .onAppear {
            viewModel.fetchSpotList()
            // 瞑想のデータ
            viewModel.meditationRecords = [
                MeditationInfo(date: Date(), worldSounds: "白神山地", meditationTime: 30),
                MeditationInfo(date: Date(), worldSounds: "ナイアガラの滝", meditationTime: 10),
                // 明日のデータ
                MeditationInfo(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, worldSounds: "万里の長城", meditationTime: 40),
                MeditationInfo(date: Date(), worldSounds: "白神山地", meditationTime: 30),
                MeditationInfo(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, worldSounds: "モン・サン・ミシェル", meditationTime: 30),
                MeditationInfo(date: Date(), worldSounds: "モン・サン・ミシェル", meditationTime: 30),
                MeditationInfo(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, worldSounds: "白神山地", meditationTime: 30),
                MeditationInfo(date: Date(), worldSounds: "モン・サン・ミシェル", meditationTime: 30),
                MeditationInfo(date: Date(), worldSounds: "ナイアガラの滝", meditationTime: 30),
                MeditationInfo(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, worldSounds: "万里の長城", meditationTime: 40)
            ]
            viewModel.calculateAchievedSpots()
        } // .onAppearここまで
    } // bodyここまで
} // Mapここまで
#Preview {
    MapView()
}
