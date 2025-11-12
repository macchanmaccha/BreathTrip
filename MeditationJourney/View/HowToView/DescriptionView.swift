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
            Color("backgroundNavy")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 24) {
                    // タイトル
                    VStack(spacing: 8) {
                        Text("アプリの使いかた")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("keyWhite"))
                    }
                    .padding(.top, 20)
                    // アプリの説明
                    VStack(alignment: .leading, spacing: 16) {
                        Text("このアプリについて")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("keyWhite"))
                        Text("世界の音を聴きながら呼吸瞑想を行い、日々の瞑想記録を残すことができます。瞑想した日はカレンダーに表示され、地図上にも記録が残ります。")
                            .font(.body)
                            .foregroundColor(Color("keyWhite").opacity(0.9))
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 20)
                    // 主要機能の説明
                    VStack(alignment: .leading, spacing: 16) {
                        Text("主要機能")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("keyWhite"))
                            .padding(.horizontal, 20)
                        VStack(spacing: 12) {
                            FeatureView(
                                icon: "speaker.wave.3.fill",
                                title: "音声ガイド",
                                description: "瞑想が初めての人向けに、瞑想中にどうすればいいか音声で教えてくれます。ON/OFFを選べます。"
                            )
                            FeatureView(
                                icon: "globe",
                                title: "大陸と国・地域の選択",
                                description: "瞑想中に聴きたい大陸や国・地域を選びます。世界各地の音が聴けます。"
                            )
                            FeatureView(
                                icon: "calendar",
                                title: "カレンダーへの記録",
                                description: "瞑想した日は、カレンダーの該当日の背景色で表示されます。"
                            )
                            FeatureView(
                                icon: "map",
                                title: "地図への記録",
                                description: "その国・地域で60分以上瞑想すると、地図にピンが立つようになります。"
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    // 重要な注意事項
                    VStack(alignment: .leading, spacing: 16) {
                        Text("注意事項")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("keyWhite"))
                            .padding(.horizontal, 20)
                        VStack(alignment: .leading, spacing: 8) {
                            NoteView(text: "「音をきく」タブは記録には残りません。瞑想の記録を残すには「瞑想」タブを使用してください。")
                        }
                        .padding(.horizontal, 20)
                    }
                    Spacer(minLength: 40)
                }
            }
        } // ZStackここまで
        .navigationBarBackButtonHidden(true)
        // 前画面へ戻る
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .tint(Color("keyWhite"))
                } // Buttonここまで
            } // ToolbarItemここまで
        }
    } // bodyここまで
} // Viewここまで

struct FeatureView: View {
    let icon: String
    let title: String
    let description: String
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // アイコン
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color("keyWhite"))
                .frame(width: 32, height: 32)
            // 内容
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("keyWhite"))
                Text(description)
                    .font(.caption)
                    .foregroundColor(Color("keyWhite").opacity(0.8))
                    .lineSpacing(2)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct NoteView: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Color.orange)
                .font(.caption)
            Text(text)
                .font(.caption)
                .foregroundColor(Color("keyWhite").opacity(0.9))
                .lineSpacing(2)
            Spacer()
        }
    }
}

#Preview {
    DescriptionView()
}
