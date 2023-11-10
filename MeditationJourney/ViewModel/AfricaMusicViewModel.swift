//
//  AfricaMusicViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/07.
//

import SwiftUI

class AfricaMusicViewModel: ObservableObject {
    @Published var musicData: [MusicDataModel] = []
    @Published var selectedMusicName: String = ""
    var africaMusicModel: AfricaMusicModel = AfricaMusicModel()
    func fetchMusic() {
        musicData = africaMusicModel.africaMusic
    }
    func getMusic(_ music: String) {
        let selectMusic = musicData.first(where: { $0.sound == music })
        selectedMusicName = selectMusic?.sound ?? ""
    }
}
