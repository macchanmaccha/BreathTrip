//
//  ExplanationView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI

struct ExplanationView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.settingsBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                // 背景枠
                Rectangle()
                    .fill(Color(.keyWhite))
                    .cornerRadius(8)
                    .opacity(0.6)
//                    .frame(width: 400, height: 400)
                VStack {
                    Text("世界の音を聴きながら\n瞑想するためのものです。\n毎日の瞑想を習慣にしましょう。")
                        .font(.title2)
                    NavigationLink(destination: WayOfMeditationView()) {
                        Text("瞑想のやりかた")
                            .font(.title2)
                            .padding(25)
                            .frame(maxWidth: 350)
                            .background(Color(.backgroundNavy))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    NavigationLink(destination: EffectOfMeditationView()) {
                        Text("瞑想の効果")
                            .font(.title2)
                            .padding(25)
                            .frame(maxWidth: 350)
                            .background(Color(.backgroundNavy))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    NavigationLink(destination: DescriptionView()) {
                        Text("アプリの使い方")
                            .font(.title2)
                            .padding(25)
                            .frame(maxWidth: 350)
                            .background(Color(.backgroundNavy))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            } // ZStackここまで
        } // NavigationStackここまで
    } // bodyここまで
} // ExplanationViewここまで

struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView()
    }
}
