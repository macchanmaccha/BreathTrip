//
//  SoundModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/12/06.
//

import Foundation
enum SoundModel: String, CaseIterable {
    case europa1 = "ヨーロッパ音1"
    case europa2 = "ヨーロッパ音2"
    case europa3 = "ヨーロッパ音3"
    case europa4 = "ヨーロッパ音4"
    case europa5 = "ヨーロッパ音5"
    case europa6 = "ヨーロッパ音6"
    case oceania1 = "オセアニア音1"
    case oceania2 = "オセアニア音2"
    case oceania3 = "オセアニア音3"
    case oceania4 = "オセアニア音4"
    case oceania5 = "オセアニア音5"
    case oceania6 = "オセアニア音6"
    case asia1 = "アジア音1"
    case asia2 = "アジア音2"
    case asia3 = "アジア音3"
    case asia4 = "アジア音4"
    case asia5 = "アジア音5"
    case asia6 = "アジア音6"
    case africa1 = "アフリカ音1"
    case africa2 = "アフリカ音2"
    case africa3 = "アフリカ音3"
    case africa4 = "アフリカ音4"
    case africa5 = "アフリカ音5"
    case africa6 = "アフリカ音6"
    case northAmerica1 = "北アメリカ1"
    case northAmerica2 = "北アメリカ2"
    case northAmerica3 = "北アメリカ3"
    case northAmerica4 = "北アメリカ4"
    case northAmerica5 = "北アメリカ5"
    case northAmerica6 = "北アメリカ6"
    case southAmerica1 = "南アメリカ1"
    case southAmerica2 = "南アメリカ2"
    case southAmerica3 = "南アメリカ3"
    case southAmerica4 = "南アメリカ4"
    case southAmerica5 = "南アメリカ5"
    case southAmerica6 = "南アメリカ6"
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
        } // switch self
    } // fileName
}
