//
//  MapPinModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/28.
//

import Foundation
import MapKit

struct SpotListModel {
    // 白神山地、万里の長城、ナイアガラの滝、モン・サン・ミシェルの緯度経度
    let spotList = [
        SpotDataModel(spotName: "白神山地", latitude: 40.4568349, longitude: 140.1645079),
        SpotDataModel(spotName: "万里の長城", latitude: 40.431906, longitude: 116.570375),
        SpotDataModel(spotName: "ナイアガラの滝", latitude: 43.082259, longitude: -79.073088),
        SpotDataModel(spotName: "モン・サン・ミシェル", latitude: 48.636014, longitude: -1.511115)
    ]
}
