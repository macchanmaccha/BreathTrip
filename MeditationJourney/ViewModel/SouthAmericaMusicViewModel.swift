//
//  SouthAmericaMusicViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/07.
//

import SwiftUI

class SouthAmericaMusicViewModel: ObservableObject {
    @Published var musicData: [MusicDataModel] = []
    @Published var selectedMusicName: String = ""
    var southAmericaMusicModel: SouthAmericaMusicModel = SouthAmericaMusicModel()
    func fetchMusic() {
        musicData = southAmericaMusicModel.southAmericaMusic
    }
    func getMusic(_ music: String) {
        let selectMusic = musicData.first(where: { $0.sound == music })
        selectedMusicName = selectMusic?.sound ?? ""
    }
}
