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
    case africa6 = "エリトリア"
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
            return "europeFile1"
        case .europa2:
            return "europeFile2"
        case .europa3:
            return "europeFile3"
        case .europa4:
            return "europeFile4"
        case .europa5:
            return "europeFile5"
        case .europa6:
            return "europeFile6"
        case .oceania1:
            return "oceaniaFile1"
        case .oceania2:
            return "oceaniaFile2"
        case .oceania3:
            return "oceaniaFile3"
        case .oceania4:
            return "oceaniaFile4"
        case .oceania5:
            return "oceaniaFile5"
        case .oceania6:
            return "oceaniaFile6"
        case .asia1:
            return "asiaFile1"
        case .asia2:
            return "asiaFile2"
        case .asia3:
            return "asiaFile3"
        case .asia4:
            return "asiaFile4"
        case .asia5:
            return "asiaFile5"
        case .asia6:
            return "asiaFile6"
        case .africa1:
            return "africaFile1"
        case .africa2:
            return "africaFile2"
        case .africa3:
            return "africaFile3"
        case .africa4:
            return "africaFile4"
        case .africa5:
            return "africaFile5"
        case .africa6:
            return "africaFile6"
        case .northAmerica1:
            return "northAmericaFile1"
        case .northAmerica2:
            return "northAmericaFile2"
        case .northAmerica3:
            return "northAmericaFile3"
        case .northAmerica4:
            return "northAmericaFile4"
        case .northAmerica5:
            return "northAmericaFile5"
        case .northAmerica6:
            return "northAmericaFile6"
        case .southAmerica1:
            return "southAmericaFile1"
        case .southAmerica2:
            return "southAmericaFile2"
        case .southAmerica3:
            return "southAmericaFile3"
        case .southAmerica4:
            return "southAmericaFile4"
        case .southAmerica5:
            return "southAmericaFile5"
        case .southAmerica6:
            return "southAmericaFile6"
        }  // switch self
    }  // fileName
}
