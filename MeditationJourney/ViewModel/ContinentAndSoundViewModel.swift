//
//  MusicDataViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/05.
//

import SwiftUI

class ContinentAndSoundViewModel: ObservableObject {
    @Published var musicData: [MusicDataModel] = []
    @Published var selectedMusicName: String = ""
    @Published var continents: [ContinentAndSoundModel] = ContinentAndSoundModel.allCases
//    func fetchMusic() {
//        musicData = musicModel.music
//    }
    func getMusic(_ music: String) {
        let selectMusic = musicData.first(where: { $0.sound == music })
        selectedMusicName = selectMusic?.sound ?? ""
    }
}
