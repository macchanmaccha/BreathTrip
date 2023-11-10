//
//  OceaniaMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/07.
//

import SwiftUI

class OceaniaMusicViewModel: ObservableObject {
    @Published var musicData: [MusicDataModel] = []
    @Published var selectedMusicName: String = ""
    var musicModel: OceaniaMusicModel = OceaniaMusicModel()
    func fetchMusic() {
        musicData = musicModel.oceaniaMusic
    }
    func getMusic(_ music: String) {
        let selectMusic = musicData.first(where: { $0.sound == music })
        selectedMusicName = selectMusic?.sound ?? ""
    }
}
