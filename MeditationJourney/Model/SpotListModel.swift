//
//  SpotListModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/28.
//

import Foundation
import MapKit

/// 音の種類に対応するスポットの緯度経度データを管理する構造体
/// SoundModelで定義されている音の種類と実際の地理的座標を対応付ける
struct SpotListModel {
    /// 音の種類に対応するスポットの緯度経度データの配列
    /// 各音の種類（スイス、イタリア、日本など）に対応する地理的座標を定義
    let spotList = [
        // ヨーロッパ
        SpotDataModel(
            spotName: "スイス",
            coordinate: CLLocationCoordinate2D(latitude: 46.8182, longitude: 8.2275)),
        SpotDataModel(
            spotName: "イタリア",
            coordinate: CLLocationCoordinate2D(latitude: 41.8719, longitude: 12.5674)),
        SpotDataModel(
            spotName: "アイルランド",
            coordinate: CLLocationCoordinate2D(latitude: 53.4129, longitude: -8.2439)),
        SpotDataModel(
            spotName: "ノルウェー",
            coordinate: CLLocationCoordinate2D(latitude: 60.4720, longitude: 8.4689)),
        SpotDataModel(
            spotName: "スペイン",
            coordinate: CLLocationCoordinate2D(latitude: 40.4637, longitude: -3.7492)),
        SpotDataModel(
            spotName: "フランス",
            coordinate: CLLocationCoordinate2D(latitude: 46.2276, longitude: 2.2137)),

        // オセアニア
        SpotDataModel(
            spotName: "ニュージーランド",
            coordinate: CLLocationCoordinate2D(latitude: -40.9006, longitude: 174.8860)),
        SpotDataModel(
            spotName: "タヒチ",
            coordinate: CLLocationCoordinate2D(latitude: -17.6797, longitude: -149.4068)),
        SpotDataModel(
            spotName: "フィジー",
            coordinate: CLLocationCoordinate2D(latitude: -16.5788, longitude: 179.4144)),
        SpotDataModel(
            spotName: "オーストラリア",
            coordinate: CLLocationCoordinate2D(latitude: -25.2744, longitude: 133.7751)),
        SpotDataModel(
            spotName: "ソロモン諸島",
            coordinate: CLLocationCoordinate2D(latitude: -9.6457, longitude: 160.1562)),
        SpotDataModel(
            spotName: "バヌアツ",
            coordinate: CLLocationCoordinate2D(latitude: -15.3767, longitude: 166.9592)),

        // アジア
        SpotDataModel(
            spotName: "インド",
            coordinate: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)),
        SpotDataModel(
            spotName: "チベット",
            coordinate: CLLocationCoordinate2D(latitude: 35.8617, longitude: 104.1954)),
        SpotDataModel(
            spotName: "日本",
            coordinate: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)),
        SpotDataModel(
            spotName: "中国",
            coordinate: CLLocationCoordinate2D(latitude: 35.8617, longitude: 104.1954)),
        SpotDataModel(
            spotName: "スリランカ",
            coordinate: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718)),
        SpotDataModel(
            spotName: "タイ",
            coordinate: CLLocationCoordinate2D(latitude: 15.8700, longitude: 100.9925)),

        // アフリカ
        SpotDataModel(
            spotName: "マダガスカル",
            coordinate: CLLocationCoordinate2D(latitude: -18.7669, longitude: 46.8691)),
        SpotDataModel(
            spotName: "南アフリカ",
            coordinate: CLLocationCoordinate2D(latitude: -30.5595, longitude: 22.9375)),
        SpotDataModel(
            spotName: "ボツワナ",
            coordinate: CLLocationCoordinate2D(latitude: -22.3285, longitude: 24.6849)),
        SpotDataModel(
            spotName: "タンザニア",
            coordinate: CLLocationCoordinate2D(latitude: -6.3690, longitude: 34.8888)),
        SpotDataModel(
            spotName: "エチオピア",
            coordinate: CLLocationCoordinate2D(latitude: 9.1450, longitude: 40.4897)),
        SpotDataModel(
            spotName: "ケニア",
            coordinate: CLLocationCoordinate2D(latitude: -0.0236, longitude: 37.9062)),

        // 北アメリカ
        SpotDataModel(
            spotName: "アメリカ",
            coordinate: CLLocationCoordinate2D(latitude: 39.8283, longitude: -98.5795)),
        SpotDataModel(
            spotName: "カリブ海",
            coordinate: CLLocationCoordinate2D(latitude: 18.5000, longitude: -66.9167)),
        SpotDataModel(
            spotName: "カナダ",
            coordinate: CLLocationCoordinate2D(latitude: 56.1304, longitude: -106.3468)),
        SpotDataModel(
            spotName: "マヤ地域",
            coordinate: CLLocationCoordinate2D(latitude: 23.6345, longitude: -102.5528)),
        SpotDataModel(
            spotName: "メキシコ",
            coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332)),
        SpotDataModel(
            spotName: "グアテマラ",
            coordinate: CLLocationCoordinate2D(latitude: 14.6407, longitude: -90.5132)),

        // 南アメリカ
        SpotDataModel(
            spotName: "ブラジル",
            coordinate: CLLocationCoordinate2D(latitude: -14.2350, longitude: -51.9253)),
        SpotDataModel(
            spotName: "ベネズエラ",
            coordinate: CLLocationCoordinate2D(latitude: 6.4238, longitude: -66.5897)),
        SpotDataModel(
            spotName: "パラグアイ",
            coordinate: CLLocationCoordinate2D(latitude: -25.2744, longitude: -57.5660)),
        SpotDataModel(
            spotName: "コスタリカ",
            coordinate: CLLocationCoordinate2D(latitude: 9.9286, longitude: -84.0907)),
        SpotDataModel(
            spotName: "ホンジュラス",
            coordinate: CLLocationCoordinate2D(latitude: 15.7835, longitude: -86.2385)),
        SpotDataModel(
            spotName: "ニカラグア",
            coordinate: CLLocationCoordinate2D(latitude: 12.1696, longitude: -86.2413))
    ]
}
