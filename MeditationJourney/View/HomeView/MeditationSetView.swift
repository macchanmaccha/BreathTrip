//
//  MeditationSetView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI

struct MeditationSetView: View {
    /// MeditatingSetViewModelをインスタンス化
    @ObservedObject var viewModel: MeditatingSetViewModel
    /// Sheetを管理する変数
    @State private var isShowSheet: Bool = false
    /// フルスクリーンを管理する変数
    @State private var isShowFullScreen: Bool = false
    /// 音声ガイドToggleを管理する変数
    @AppStorage(UserDefaultsKey.audioGuide) private var isAudioGuideOn: Bool = false
    /// 選択できる分数
    private let minutesOptions: [Int] = [1, 3, 5, 10, 20, 30, 40, 50, 60]
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
                        .frame(width: 350, height: 180)
                    VStack {
                        HStack {
                            Text("音声ガイド")
                                .font(.title2)
                            Spacer()
                            VStack {
                                // 音声ガイドボタン
                                Button(action: {
                                    isAudioGuideOn.toggle()
                                }) {
                                    Image(systemName: isAudioGuideOn
                                          ? "speaker.wave.3.fill"
                                          : "speaker.slash.fill")
                                    .frame(width: 30, height: 30)
                                    .font(.title)
                                }  // Buttonここまで
                                // ON、OFFのテキスト表示
                                Text( isAudioGuideOn ? "ON" : "OFF")
                                    .frame(width: 30, height: 5)
                                    .font(.caption2)
                            }  // VStackここまで
                        }  // HStackここまで
                        .frame(width: 300, height: 40)
                        // 線を入れる
                        Divider()
                        // 時間設定
                        HStack {
                            Text("時間")
                                .font(.title2)
                            Spacer()
                            Picker("時間を選ぶ", selection: $viewModel.meditationMinutes) {
                                ForEach(minutesOptions, id: \.self) { minutes in
                                    Text("\(minutes)分")
                                }  // ForEachここまで
                            }  // Pickerここまで
                            .tint(.backgroundNavy)
                            .scaleEffect(CGSize(width: 1.25, height: 1.25))
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: viewModel.meditationMinutes) {
                                viewModel.saveMeditationMinutes()
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
                                Text(viewModel.listeningSoundName.rawValue)
                                Image(systemName: "chevron.right")
                            }
                        }  // HStackここまで
                        .font(.title2)
                        .frame(width: 300, height: 40)
                    }  // VStackここまで
                }
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
                        MeditatingView(viewModel: viewModel)
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
}  // MeditationViewここまで

struct MeditationSetView_Previews: PreviewProvider {
    // ここではpreview用のCoreDataが渡される
    static let viewModel = MeditatingSetViewModel(context: PersistenceController.preview.container.viewContext)
    static var previews: some View {
        MeditationSetView(viewModel: viewModel)
        // ✅ タブの表示名
            .previewDevice(PreviewDevice(rawValue: "iPhone 16"))
        // ✅ プレビューする端末（プレビューデバイス）を指定
            .previewDisplayName("iPhone 16")
        MeditationSetView(viewModel: viewModel)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            .previewDisplayName("iPad Pro (11-inch)")
    }
}
