//
//  MapView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import MapKit
import SwiftUI

struct MapView: View {
    // viewModelのインスタンス化
    @ObservedObject var viewModel: SpotListViewModel
    // マップの中心の情報、緯度経度、範囲
    @State private var region: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: .init(latitude: 35.682839, longitude: 139.759455),
            span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 60)
        ))
    var body: some View {
        VStack {
            // 地図の表示およびマーカーの表示
            Map(position: $region) {
                ForEach(viewModel.achievedSpots, id: \.id) { spot in
                    Marker(spot.spotName, coordinate: spot.coordinate)
                }  // ForEach
            }  // Map
            // ダークモード
            .colorScheme(.dark)
        }  // VStack
        .onAppear {
            viewModel.fetchSpotList()
            // 瞑想のデータ
            viewModel.loadMeditationRecords()
            viewModel.calculateAchievedSpots()
        }  // .onAppearここまで
    }  // bodyここまで
}  // Mapここまで
#Preview {
    let viewModel = SpotListViewModel(context: PersistenceController.preview.container.viewContext)
    MapView(viewModel: viewModel)
}
