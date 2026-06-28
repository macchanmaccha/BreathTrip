//
//  DescriptionView.swift
//  MeditationJourney
//
//  Created by apple on 2024/06/26.
//

import SwiftUI

struct DescriptionView: View {
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
                    Text("アプリの使いかた")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.keyWhite)
                        .padding(.top, 20)
                    // アプリの説明
                    VStack(alignment: .leading, spacing: 16) {
                        Text("このアプリについて")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.keyWhite)
                        Text("世界の音を聴きながら呼吸瞑想を行い、日々の瞑想記録を残すことができます。瞑想した日はカレンダーに表示され、地図上にも記録が残ります。")
                            .font(.body)
                            .foregroundStyle(.keyWhite)
                            .opacity(0.8)
                            .lineSpacing(4)
                    }
                    // 機能
                    VStack(alignment: .leading, spacing: 16) {
                        Text("機能")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.keyWhite)
                        VStack(spacing: 12) {
                            FeatureView(
                                icon: "speaker.wave.3.fill",
                                title: "音声ガイド",
                                description: "瞑想が初めての人向けに、瞑想中にどうすればいいか音声で教えてくれます。ON/OFFを切り替えられます。"
                            )
                            FeatureView(
                                icon: "globe",
                                title: "大陸と国・地域の選択",
                                description: "瞑想中に聴きたい大陸や国・地域の音を選択します。世界旅行をしている気分で瞑想ができます。"
                            )
                            FeatureView(
                                icon: "calendar",
                                title: "カレンダーへの記録",
                                description: "瞑想した日は、カレンダーの該当日に背景色が表示されるようになります。瞑想時間によって色が変わります。"
                            )
                            FeatureView(
                                icon: "map",
                                title: "地図への記録",
                                description: "その国・地域の音で60分以上瞑想すると、地図にピンが立つようになります。"
                            )
                        }
                    }
                    // 注意事項
                    VStack(alignment: .leading, spacing: 16) {
                        Text("注意事項")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.keyWhite)
                        NoteView(text: "記録を残したい場合は「瞑想」を使用してください。「音をきく」では記録は残りません。")
                    }
                }
                // 左右に20ポイント、下部に40ポイントのパディングを指定
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
            }
        } // ZStackここまで
    } // bodyここまで
} // Viewここまで

private extension DescriptionView {
    struct FeatureView: View {
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
    struct NoteView: View {
        let text: String
        var body: some View {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                    .font(.caption)
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.keyWhite)
                    .opacity(0.8)
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    DescriptionView()
}
