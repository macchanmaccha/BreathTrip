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
    // 場所の名前
    let spotName: String
    // 緯度
    var latitude: Double {
        coordinate.latitude
    }
    // 経度
    var longitude: Double {
        coordinate.longitude
    }
    // 緯度経度
    let coordinate: CLLocationCoordinate2D
}
