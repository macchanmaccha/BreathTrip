//
//  MapSpotModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/27.
//

import Foundation
import MapKit

// Identifiableプロトコルを利用して、ピンのスポットの情報をまとめる構造体
struct SpotDataModel: Identifiable {
    let id = UUID()
    // 緯度
    let latitude: Double
    // 経度
    let longitude: Double
    // 緯度経度
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
