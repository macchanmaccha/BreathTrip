//
//  SoundModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/12/06.
//

import Foundation

enum SoundModel: String, CaseIterable {
    case europa1 = "スイス"
    case europa2 = "イタリア"
    case europa3 = "アイルランド"
    case europa4 = "ノルウェー"
    case europa5 = "スペイン"
    case europa6 = "フランス"
    case oceania1 = "ニュージーランド"
    case oceania2 = "タヒチ"
    case oceania3 = "フィジー"
    case oceania4 = "オーストラリア"
    case oceania5 = "ソロモン諸島"
    case oceania6 = "バヌアツ"
    case asia1 = "インド"
    case asia2 = "チベット"
    case asia3 = "日本"
    case asia4 = "中国"
    case asia5 = "スリランカ"
    case asia6 = "タイ"
    case africa1 = "マダガスカル"
    case africa2 = "南アフリカ"
    case africa3 = "ボツワナ"
    case africa4 = "タンザニア"
    case africa5 = "エチオピア"
    case africa6 = "ケニア"
    case northAmerica1 = "アメリカ"
    case northAmerica2 = "カリブ海"
    case northAmerica3 = "カナダ"
    case northAmerica4 = "マヤ地域"
    case northAmerica5 = "メキシコ"
    case northAmerica6 = "グアテマラ"
    case southAmerica1 = "ブラジル"
    case southAmerica2 = "ベネズエラ"
    case southAmerica3 = "パラグアイ"
    case southAmerica4 = "コスタリカ"
    case southAmerica5 = "ホンジュラス"
    case southAmerica6 = "ニカラグア"
    var fileName: String {
        switch self {
        case .europa1:
            return "939898359"
        case .europa2:
            return "848536284"
        case .europa3:
            return "1267896993"
        case .europa4:
            return "1656186853"
        case .europa5:
            return "1613642543"
        case .europa6:
            return "848153433"
        case .oceania1:
            return "1449436957"
        case .oceania2:
            return "1578090841"
        case .oceania3:
            return "1436676828"
        case .oceania4:
            return "1643660832"
        case .oceania5:
            return "79156456"
        case .oceania6:
            return "1459456814"
        case .asia1:
            return "1450602373"
        case .asia2:
            return "1640689188"
        case .asia3:
            return "1562655504"
        case .asia4:
            return "1212878303"
        case .asia5:
            return "1612792722"
        case .asia6:
            return "468231577"
        case .africa1:
            return "957218111"
        case .africa2:
            return "1462013003"
        case .africa3:
            return "1591131260"
        case .africa4:
            return "1591131273"
        case .africa5:
            return "1350823744"
        case .africa6:
            return "1563265249"
        case .northAmerica1:
            return "1780877431"
        case .northAmerica2:
            return "1096737554"
        case .northAmerica3:
            return "1565768729"
        case .northAmerica4:
            return "1437327789"
        case .northAmerica5:
            return "1438587595"
        case .northAmerica6:
            return "1440586504"
        case .southAmerica1:
            return "1592085636"
        case .southAmerica2:
            return "183070773"
        case .southAmerica3:
            return "339105862"
        case .southAmerica4:
            return "1465062611"
        case .southAmerica5:
            return "1542412635"
        case .southAmerica6:
            return "1542412646"
        }  // switch self
    }  // fileName
}
