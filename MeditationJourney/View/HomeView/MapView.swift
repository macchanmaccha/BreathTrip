//
//  MapView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 35.682839, longitude: 139.759455),
        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
    )
    // 白神山地、万里の長城、ナイアガラの滝、モン・サン・ミシェル
    let spotList = [
        Spot(latitude: 40.4568349, longitude: 140.1645079),
        Spot(latitude: 40.431906, longitude: 116.570375),
        Spot(latitude: 43.082259, longitude: -79.073088),
        Spot(latitude: 48.636014, longitude: -1.511115)
    ]

    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: spotList,
            annotationContent: { spot in
            MapMarker(coordinate: spot.coordinate, tint: .red)
        })
    } // bodyここまで
}
#Preview {
    SelectContinentView()
}
