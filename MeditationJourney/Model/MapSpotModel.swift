//
//  MapSpotModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/27.
//

import Foundation
import MapKit

struct Spot: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
