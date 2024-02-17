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
        GeometryReader { geometry in
            VStack {
                // 地図の表示およびマーカーの表示
                Map(position: $region) {
                    ForEach(viewModel.spotList, id: \.id) { spot in
                        Marker(spot.spotName, coordinate: spot.coordinate)
                    } // ForEach
                } // Map
            } // VStack
            // Safe Areaの余白を考慮する
            .padding(.bottom, geometry.safeAreaInsets.bottom)
        } // GeometryReader
        .onAppear {
            viewModel.fetchSpotList()
        } // .onAppearここまで
    } // bodyここまで
} // Mapここまで
#Preview {
    MapView()
}
