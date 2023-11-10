//
//  MusicDataViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/05.
//

import SwiftUI

class EuropeMusicViewModel: ObservableObject {
    @Published var musicData: [MusicDataModel] = []
    @Published var selectedMusicName: String = ""
    var musicModel: EuropeMusicModel = EuropeMusicModel()
    func fetchMusic() {
        musicData = musicModel.europeMusic
    }
    func getMusic(_ music: String) {
        let selectMusic = musicData.first(where: { $0.sound == music })
        selectedMusicName = selectMusic?.sound ?? ""
    }
}
