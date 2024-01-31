//
//  MapView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI
import MapKit

struct MapView: View {
    // マップ表示　緯度経度　範囲の情報
    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 35.682839, longitude: 139.759455),
        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
    )
    @StateObject var spotListViewModel: SpotListViewModel = SpotListViewModel()
    var body: some View {
        // 地図の表示
        Map(coordinateRegion: $region,
            annotationItems: spotListViewModel.spotList,
            annotationContent: { spot in
            MapMarker(coordinate: spot.coordinate, tint: .red)
        })
        .ignoresSafeArea()
        .onAppear {
            spotListViewModel.fetchSpotList()
        } // .onAppearここまで
    } // bodyここまで
}
#Preview {
    MapView()
}
