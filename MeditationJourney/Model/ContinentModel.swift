//
//  EuropeMusicModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/06.
//

import Foundation

enum ContinentModel: String, CaseIterable {
    case europe = "ヨーロッパ大陸"
    case oceania = "オセアニア大陸"
    case asia = "アジア大陸"
    case africa = "アフリカ大陸"
    case northAmerica = "北アメリカ大陸"
    case southAmerica = "南アメリカ大陸"
    var soundList: [SoundModel] {
        switch self {
        case .europe:
            return [.europa1, .europa2, .europa3, .europa4, .europa5, .europa6]
        case .oceania:
            return [.oceania1, .oceania2, .oceania3, .oceania4, .oceania5, .oceania6]
        case .asia:
            return [.asia1, .asia2, .asia3, .asia4, .asia5, .asia6]
        case .africa:
            return [.africa1, .africa2, .africa3, .africa4, .africa5, .africa6]
        case .northAmerica:
            return [
                .northAmerica1, .northAmerica2, .northAmerica3, .northAmerica4, .northAmerica5,
                .northAmerica6
            ]
        case .southAmerica:
            return [
                .southAmerica1, .southAmerica2, .southAmerica3, .southAmerica4, .southAmerica5,
                .southAmerica6
            ]
        }  // switch selfここまで
    }  // soundListここまで
}  // enum ここまで
