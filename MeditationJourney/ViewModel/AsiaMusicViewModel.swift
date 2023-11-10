//
//  AsiaMusicViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/07.
//

import SwiftUI

class AsiaMusicViewModel: ObservableObject {
    @Published var musicData: [MusicDataModel] = []
    @Published var selectedMusicName: String = ""
    var asiaMusicModel: AsiaMusicModel = AsiaMusicModel()
    func fetchMusic() {
        musicData = asiaMusicModel.asiaMusic
    }
    func getMusic(_ music: String) {
        let selectMusic = musicData.first(where: { $0.sound == music })
        selectedMusicName = selectMusic?.sound ?? ""
    }
}
