//
//  MusicDataViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/05.
//

import SwiftUI

class ContinentAndSoundViewModel: ObservableObject {
    // 大陸の変数
    @Published var continents: [ContinentAndSoundModel] = ContinentAndSoundModel.allCases
}
