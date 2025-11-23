//
//  WayOfMeditationView.swift
//  MeditationJourney
//
//  Created by apple on 2024/06/26.
//

import SwiftUI

struct WayOfMeditationView: View {
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
                        Text("瞑想のやりかた")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.keyWhite)
                        Text("このアプリでは呼吸瞑想を基本としています")
                            .font(.subheadline)
                            .foregroundStyle(.keyWhite)
                            .opacity(0.8)
                    } // VStack
                    .padding(.top, 20)
                    // 説明文
                    VStack(alignment: .leading, spacing: 16) {
                        Text("呼吸瞑想とは")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.keyWhite)
                        Text("呼吸に意識を向けることで、心を静め、今この瞬間に集中する瞑想法です。このアプリでは、世界の音を聴きながら呼吸瞑想を行います。")
                            .font(.body)
                            .foregroundStyle(.keyWhite)
                            .opacity(0.9)
                            .lineSpacing(4)
                    }
                    // ステップ
                    VStack(alignment: .leading, spacing: 16) {
                        Text("やりかた")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.keyWhite)
                        VStack(spacing: 12) {
                            StepView(
                                number: 1, title: "姿勢を整える", description: "背筋を伸ばして座り、リラックスした姿勢を保ちます")
                            StepView(
                                number: 2, title: "目を閉じる", description: "静かに目を閉じて、外の刺激から意識を離します")
                            StepView(
                                number: 3, title: "呼吸に集中", description: "自然な呼吸を感じ、息を吸う・吐く感覚に意識を向けます"
                            )
                            StepView(
                                number: 4, title: "雑念を手放す",
                                description: "他のことを考えても大丈夫。再び呼吸に意識を戻しましょう")
                        }
                    }
                    // ポイント
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ポイント")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.keyWhite)
                        VStack(alignment: .leading, spacing: 8) {
                            PointView(text: "完璧を求めず、今できることを大切に")
                            PointView(text: "毎日少しずつでも続けることが重要")
                            PointView(text: "雑念が浮かんでも自分を責めない")
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }  // ZStackここまで
        .navigationBarBackButtonHidden(true)
        // 前画面へ戻る
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .tint(Color("keyWhite"))
                }  // Buttonここまで
            }  // ToolbarItemここまで
        }
    }  // bodyここまで
}  // Viewここまで

private extension WayOfMeditationView {
    struct StepView: View {
        let number: Int
        let title: String
        let description: String
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                // ステップ番号
                Text("\(number)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.backgroundNavy)
                    .frame(width: 28, height: 28)
                    .background(.keyWhite)
                    .clipShape(Circle())
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
    struct PointView: View {
        let text: String
        var body: some View {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
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
    WayOfMeditationView()
}
