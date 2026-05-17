//
//  SelectContinentMusicView.swift
//  MeditationJourney
//
//  Created by apple on 2023/10/09.
//

import SwiftUI

struct ListeningSetView: View {
    /// ListeningSetViewModelをインスタンス化
    @ObservedObject var viewModel: ListeningSetViewModel
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
                .ignoresSafeArea(.all)
            // RectangleとはじめるボタンのVStack
            VStack {
                ZStack {
                    // 背景枠
                    Rectangle()
                        .fill(.keyWhite)
                        .clipShape(.rect(cornerRadius: 8))
                        .opacity(0.6)
                        .frame(width: 350, height: 130)
                    VStack {
                        // 時間設定
                        HStack {
                            Text("時間")
                            Spacer()
                            Picker("時間を選ぶ", selection: $viewModel.listeningMinutes) {
                                ForEach(minutesOptions, id: \.self) { minute in
                                    let minuteText = minute != 1440 ? "\(minute)分" : "時間制限なし"
                                    Text(minuteText)
                                        .tag(minute)
                                }
                            }  // Pickerここまで
                            .tint(.backgroundNavy)
                            .scaleEffect(CGSize(width: 1.25, height: 1.25))
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: viewModel.listeningMinutes) {
                                viewModel.saveListeningMinutes()
                            }
                        }  // HStackここまで
                        .frame(width: 300, height: 40)
                        Divider()
                        // 音設定
                        HStack {
                            Text("音")
                            Spacer()
                            Button(action: {
                                isShowSheet.toggle()
                            }) {
                                Text("\(viewModel.listeningSoundName.rawValue)>")
                            }
                        } // HStackここまで
                        .frame(width: 300, height: 40)
                    }
                }
                .font(.title2)
                .foregroundStyle(.backgroundNavy)
                // はじめるボタン
                Button(action: {
                    // プレビューURLを取得（認証チェックも含む）
                    Task {
                        // 認証とプレビューURLの取得が成功した場合のみフルスクリーンを表示
                        if await viewModel.fetchPreviewURL(for: viewModel.trackID) {
                            // プレビューURLの取得完了後にフルスクリーンを表示
                            isShowFullScreen.toggle()
                        }
                    }
                }) {
                    Text("はじめる")
                        .font(.title)
                        .foregroundStyle(.keyWhite)
                        .padding(25.0)
                        .background(.backgroundNavy)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .fullScreenCover(
                    isPresented: $isShowFullScreen,
                    content: {
                        ListeningView(viewModel: viewModel)
                    }
                )
                .padding()
            } // RectangleとはじめるボタンのVStack
        }  // ZStackここまで
        .tint(.blue)
        // AppleMusicへのアクセスが許可されなかった時に、設定画面への遷移を促すアラート
        .alert(
            "メディアとApple Musicへのアクセスがオフになっています",
            isPresented: $viewModel.isShowAlert
        ) {
            Button("設定を開く") {
                // 設定アプリの自分のアプリの設定画面を開く
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            Button("キャンセル", role: .cancel) { }
        } message: {
            Text("この機能を使うにはメディアとApple Musicへのアクセスをオンにしてください。")
        }  // .alertここまで
        // シート
        .sheet(
            isPresented: $isShowSheet,
            content: {
                SelectContinentView(viewModel: viewModel, isShowSheet: $isShowSheet)
            })
    }  // bodyここまで
}  // ListeningSetViewここまで

#Preview {
    ListeningSetView(viewModel: ListeningSetViewModel())
}
