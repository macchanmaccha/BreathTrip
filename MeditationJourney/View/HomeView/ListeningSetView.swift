//
//  SelectContinentMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct ListeningSetView: View {
    /// listeningSetViewModelをインスタンス化
    @StateObject private var viewModel: ListeningSetViewModel = ListeningSetViewModel()
    /// Sheetを管理する変数
    @State private var isShowSheet: Bool = false
    /// フルスクリーンを管理する変数
    @State private var isShowFullScreen: Bool = false
    /// 選択できる分数
    private let minutesOptions: [Int] = [10, 20, 30, 40, 50, 60, 1440]
    var body: some View {
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
                .frame(width: 400, height: 400)
            VStack {
                Spacer()
                // 時間設定
                HStack {
                    Text("時間")
                        .font(.title2)
                        .foregroundStyle(.backgroundNavy)
                    Spacer()
                    Picker("時間を選ぶ", selection: $viewModel.listeningMinutes) {
                        ForEach(minutesOptions, id: \.self) { minute in
                            let minuteText = minute != 1440 ? "\(minute)分" : "時間制限なし"
                            Text(minuteText)
                                .tag(minute)
                        }
                    }  // Pickerここまで
                    .colorMultiply(.backgroundNavy)
                    .scaleEffect(CGSize(width: 1.25, height: 1.25))
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: viewModel.listeningMinutes) {
                        viewModel.saveListeningMinutes()
                    }
                }  // HStackここまで
                .foregroundStyle(.backgroundNavy)
                .frame(width: 200)
                .padding()
                // 音設定
                HStack {
                    Text("音")
                        .font(.title2)
                        .foregroundStyle(.backgroundNavy)
                    Spacer()
                    Button(action: {
                        isShowSheet.toggle()
                    }) {
                        Text("\(viewModel.listeningSoundName.rawValue)>")
                            .font(.title2)
                            .foregroundStyle(.backgroundNavy)
                    }
                }  // HStackここまで
                .frame(width: 200)
                .padding()
                // はじめるボタン
                Button(action: {
                    // プレビューURLを取得（認証チェックも含む）
                    Task {
                        // 認証とプレビューURLの取得が成功した場合のみフルスクリーンを表示
                        let success = await viewModel.fetchPreviewURL(for: viewModel.trackID)
                        if success {
                        // プレビューURLの取得完了後にフルスクリーンを表示
                        await MainActor.run {
                            isShowFullScreen.toggle()
                            }
                        }
                    }
                }) {
                    Text("はじめる")
                        .font(.title)
                        .foregroundStyle(.keyWhite)
                        .padding(25.0)
                        .background(.backgroundNavy)
                        .cornerRadius(10)
                }
                .fullScreenCover(
                    isPresented: $isShowFullScreen,
                    content: {
                        ListeningView(viewModel: viewModel)
                    }
                )
                .padding()
                Spacer()
            }  // VStackここまで
        }  // ZStackここまで
        .accentColor(.blue)
        // AppleMusicへのアクセスが許可されなかった時に、設定画面への遷移を促すアラート
        .alert(isPresented: $viewModel.isShowAlert) {
            Alert(
                title: Text("メディアとApple Musicへのアクセスがオフになっています"),
                message: Text("この機能を使うにはメディアとApple Musicへのアクセスをオンにしてください。\n\n設定画面で「アプリ」→「MeditationJourney」→「メディアとApple Music」の順にタップし、アクセスを許可してください。"),
                primaryButton: .default(Text("設定を開く")) {
                    // 設定アプリの自分のアプリの設定画面を開く
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                },
                secondaryButton: .cancel(Text("キャンセル"))
            )  // Alert
        }  // .alertここまで
        // シート
        .sheet(
            isPresented: $isShowSheet,
            content: {
                SelectContinentView(viewModel: viewModel, isShowSheet: $isShowSheet)
            })
    }  // bodyここまで
}  // SoundSetViewここまで

#Preview {
    ListeningSetView()
}
