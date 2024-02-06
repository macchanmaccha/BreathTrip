//
//  MapView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let shirakamisanchi = CLLocationCoordinate2D(latitude: 40.4568349, longitude: 140.1645079)
    static let banrinotyoujou = CLLocationCoordinate2D(latitude: 40.431906, longitude: 116.570375)
    static let naiagaranotaki = CLLocationCoordinate2D(latitude: 43.082259, longitude: -79.073088)
    static let monsanmishel = CLLocationCoordinate2D(latitude: 48.636014, longitude: -1.511115)
//    SpotDataModel(spotName: "白神山地", latitude: 40.4568349, longitude: 140.1645079),
//    SpotDataModel(spotName: "万里の長城", latitude: 40.431906, longitude: 116.570375),
//    SpotDataModel(spotName: "ナイアガラの滝", latitude: 43.082259, longitude: -79.073088),
//    SpotDataModel(spotName: "モン・サン・ミシェル", latitude: 48.636014, longitude: -1.511115)
}
    struct MapView: View {
        // マップ表示　緯度経度　範囲の情報
        //    @State private var region = MKCoordinateRegion(
        //        center: .init(latitude: 35.682839, longitude: 139.759455),
        //        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
        //    )
        @StateObject var viewModel: SpotListViewModel = SpotListViewModel()
        var body: some View {
            // 地図の表示
            Map {
                Marker("白神山地", coordinate: .shirakamisanchi)
                Marker("万里の長城", coordinate: .banrinotyoujou)
                Marker("ナイアガラの滝", coordinate: .naiagaranotaki)
                Marker("モン・サン・ミシェル", coordinate: .monsanmishel)
            }
            //        Map(coordinateRegion: $region,
            //            annotationItems: spotListViewModel.spotList,
            //            annotationContent: { spot in
            //            MapMarker(coordinate: spot.coordinate, tint: .red)
            //        })
            .ignoresSafeArea()
            .onAppear {
                viewModel.fetchSpotList()
            } // .onAppearここまで
        } // bodyここまで
    }
    #Preview {
        MapView()
    }
