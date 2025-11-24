//
//  EffectOfMeditationView.swift
//  MeditationJourney
//
//  Created by apple on 2024/06/26.
//

import SwiftUI

struct EffectOfMeditationView: View {
    /// 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            // 背景色を紺色に設定
            Color(.backgroundNavy)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {
                    // タイトル
                    VStack(spacing: 8) {
                        Text("瞑想の効果")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.keyWhite)
                        Text("継続することで得られる様々な効果")
                            .font(.subheadline)
                            .foregroundStyle(.keyWhite)
                            .opacity(0.8)
                    }
                    .padding(.top, 20)
                    // 説明文
                    VStack(alignment: .leading, spacing: 16) {
                        Text("瞑想の効果について")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.keyWhite)
                        Text("瞑想を継続すると、心身に様々な良い変化が現れます。科学的にも多くの効果が証明されています。")
                            .font(.body)
                            .foregroundStyle(.keyWhite)
                            .opacity(0.9)
                            .lineSpacing(4)
                    }
                    // 効果一覧
                    VStack(alignment: .leading, spacing: 16) {
                        Text("主な効果")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.keyWhite)
                            .padding(.horizontal, 20)
                        VStack(spacing: 12) {
                            EffectView(
                                icon: "brain.head.profile",
                                title: "ストレス軽減",
                                description: "心の緊張がほぐれ、リラックス効果が得られます"
                            )
                            EffectView(
                                icon: "heart.fill",
                                title: "集中力向上",
                                description: "注意力が高まり、作業効率が向上します"
                            )
                            EffectView(
                                icon: "moon.fill",
                                title: "睡眠の質向上",
                                description: "深いリラックスにより、より良い睡眠が得られます"
                            )
                            EffectView(
                                icon: "face.smiling",
                                title: "感情の安定",
                                description: "感情のコントロールが上手になり、穏やかな気持ちを保てます"
                            )
                            EffectView(
                                icon: "figure.walk",
                                title: "免疫力向上",
                                description: "心身のバランスが整い、健康な体づくりに役立ちます"
                            )
                        }
                    }
                    // 継続のコツ
                    VStack(alignment: .leading, spacing: 12) {
                        Text("継続のコツ")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.keyWhite)
                            .padding(.horizontal, 20)
                        VStack(alignment: .leading, spacing: 8) {
                            TipView(text: "毎日少しずつでも続けることが大切")
                            TipView(text: "完璧を求めず、自分のペースで行う")
                            TipView(text: "効果を実感するまで時間がかかることもある")
                            TipView(text: "無理をせず、楽しみながら取り組む")
                        }
                    }
                }
                // 左右に20ポイント、下部に40ポイントのパディングを指定
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
            } // ScrollView
        } // ZStackここまで
        .navigationBarBackButtonHidden(true)
        // 前画面へ戻る
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .tint(.keyWhite)
                } // Buttonここまで
            } // ToolbarItemここまで
        }
    } // bodyここまで
} // Viewここまで

private extension EffectOfMeditationView {
    struct EffectView: View {
        let icon: String
        let title: String
        let description: String
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                // アイコン
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.keyWhite)
                    .frame(width: 32, height: 32)
                // 内容
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.keyWhite)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.keyWhite)
                        .opacity(0.8)
                        .lineSpacing(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
        }
    }
    struct TipView: View {
        let text: String
        var body: some View {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.keyWhite)
                    .font(.caption)
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.keyWhite)
                    .opacity(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    EffectOfMeditationView()
}
