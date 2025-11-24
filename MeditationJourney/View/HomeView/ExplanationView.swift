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
                    .fill(.keyWhite)
                    .cornerRadius(8)
                    .opacity(0.6)
                VStack {
                    Text("このアプリは、\n世界の音を聴きながら\n瞑想の旅へ出かけることができます。")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    // 瞑想のやり方を説明する画面へ遷
                    NavigationLink(destination: WayOfMeditationView()) {
                        HStack {
                            Image(systemName: "figure.mind.and.body")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.horizontal)
                            Text("瞑想のやりかた")
                        }
                        .font(.title2)
                        .padding(20)
                        .frame(maxWidth: 350, alignment: .leading)
                        .background(.backgroundNavy)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                    }
                    .padding(5)
                    // 瞑想の効果を説明する画面へ遷移
                    NavigationLink(destination: EffectOfMeditationView()) {
                        HStack {
                            Image(systemName: "heart.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.horizontal)
                            Text("瞑想の効果")
                        }
                        .font(.title2)
                        .padding(20)
                        .frame(maxWidth: 350, alignment: .leading)
                        .background(.backgroundNavy)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                    }
                    .padding(5)
                    // アプリの使い方を説明する画面へ遷移
                    NavigationLink(destination: DescriptionView()) {
                        HStack {
                            Image(systemName: "person.fill.questionmark")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.horizontal)
                            Text("アプリの使い方")
                        }
                        .font(.title2)
                        .padding(20)
                        .frame(maxWidth: 350, alignment: .leading)
                        .background(.backgroundNavy)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                    }
                    .padding(5)
                }
            }  // ZStackここまで
        }  // NavigationStackここまで
    }  // bodyここまで
}  // ExplanationViewここまで

struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView()
    }
}
