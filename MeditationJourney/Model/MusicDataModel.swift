//
//  MusicModel.swift
//  MeditationJourney
//
//  Created by apple on 2023/11/05.
//

import Foundation

// Identifiableプロトコルを利用して、音の情報をまとめる構造体
struct MusicDataModel: Identifiable {
    let id = UUID()
    // 大陸
    let continent: String
    // 音
    let sound: String
}
