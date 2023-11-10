//
//  NorthAmericaMusicViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/07.
//

import SwiftUI

class NorthAmericaMusicViewModel: ObservableObject {
    @Published var musicData: [MusicDataModel] = []
    @Published var selectedMusicName: String = ""
    var northAmericaMusicModel: NorthAmericaMusicModel = NorthAmericaMusicModel()
    func fetchMusic() {
        musicData = northAmericaMusicModel.northAmericaMusic
    }
    func getMusic(_ music: String) {
        let selectMusic = musicData.first(where: { $0.sound == music })
        selectedMusicName = selectMusic?.sound ?? ""
    }
}
