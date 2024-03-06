//
//  SelectContinentMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct SoundSetView: View {
    // MeditatingSetViewModelをインスタンス化
    @StateObject private var viewModel: MeditatingSetViewModel = MeditatingSetViewModel()
    // Sheetを管理する変数
    @State private var isShowSheet: Bool = false
    // フルスクリーンを管理する変数
    @State private var isShowFullScreen: Bool = false
    // 選択できる分数
    private let minutesOptions: [Int?] = [20, 30, 40, 50, 60, nil]
    var body: some View {
       Text("")
    } // bodyここまで
} // SoundSetViewここまで

#Preview {
    SoundSetView()
}
