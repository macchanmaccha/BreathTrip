//
//  EuropeMusicModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/06.
//

import Foundation

enum ContinentAndSoundModel: String, CaseIterable {
    case europe = "ヨーロッパ大陸"
    case oceania = "オセアニア大陸"
    case asia = "アジア大陸"
    case africa = "アフリカ大陸"
    case nourthAmerica = "北アメリカ大陸"
    case southAmerica = "南アメリカ大陸"
    var soundList: [String] {
        switch self {
        case .europe:
            return ["ヨーロッパ音1", "ヨーロッパ音2", "ヨーロッパ音3", "ヨーロッパ音4", "ヨーロッパ音5", "ヨーロッパ音6"]
        case .oceania:
            return ["オセアニア音1", "オセアニア音2", "オセアニア音3", "オセアニア音4", "オセアニア音5", "オセアニア音6"]
        case .asia:
            return ["アジア音1", "アジア音2", "アジア音3", "アジア音4", "アジア音5", "アジア音6"]
        case .africa:
            return ["アフリカ音1", "アフリカ音2", "アフリカ音3", "アフリカ音4", "アフリカ音5", "アフリカ音6"]
        case .nourthAmerica:
            return ["北アメリカ音1", "北アメリカ音2", "北アメリカ音3", "北アメリカ音4", "北アメリカ音5", "北アメリカ音6"]
        case .southAmerica:
            return ["南アメリカ音1", "南アメリカ音2", "南アメリカ音3", "南アメリカ音4", "南アメリカ音5", "南アメリカ音6"]
        } // switch selfここまで
    } // soundListここまで
} // enum ここまで
