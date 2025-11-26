//
//  MeditatingView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/23.
//

import AVFoundation
import MusicKit
import SwiftUI

struct MeditatingView: View {
    /// MeditatingSetViewModel
    @ObservedObject var viewModel: MeditatingSetViewModel
    /// 瞑想中断アラートを管理する変数
    @State private var isShowStopAlert: Bool = false
    /// 瞑想終了アラートを管理する変数
    @State private var isShowEndAlert: Bool = false
    /// 画面を閉じるプロパティラッパー
    @Environment(\.dismiss) private var dismiss
    /// プレビューURL
    @State private var previewURL: URL?
    /// 曲のID
    private let trackID: String = "848536284"
    /// プレイヤー
    @State private var audioPlayer: AVPlayer?
    var body: some View {
        ZStack {
            Image(.playBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                // preStartまたはprePauseのとき
                if viewModel.state == .preStart || viewModel.state == .prePause {
                    // 以下テキストを表示
                    Text("開始まで\n\(viewModel.remainingSeconds)")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 30))
                        .frame(width: 200, height: 200)
                        .bold()
                }
                // 瞑想中タイマーを表示
                if viewModel.state == .start || viewModel.state == .pause {
                    Text(viewModel.remainingSeconds.formattedTime())
                        .foregroundStyle(.keyWhite)
                        .font(.system(size: 80))
                        .frame(width: 300, height: 200)
                        .bold()
                    // プレビューURLが存在したら
                    if previewURL != nil {
                        // 再生状態をplayingにする
//                        updateState(newState: .playing)
                    } else {
                    }  // if previewURL
                }
                // endでないとき
                if viewModel.state != .end {
                    // 中断ボタン
                    Button(action: {
                        // preStartだったら
                        if viewModel.state == .preStart {
                            // prePauseにする
                            viewModel.updateState(to: .prePause)
                            // startだったら
                        } else if viewModel.state == .start {
                            // pauseにする
                            viewModel.updateState(to: .pause)
                        }
                    }) {
                        Text("中断する")
                            .tint(.backgroundNavy)
                            .font(.title)
                    }
                    .padding(25)
                    .background(.keyWhite)
                    .cornerRadius(10)
                    .alert("", isPresented: $isShowStopAlert) {
                        // NO
                        Button("NO") {
                            // prePauseだったら
                            if viewModel.state == .prePause {
                                // preStartにする
                                viewModel.updateState(to: .preStart)
                                // pauseだったら
                            } else if viewModel.state == .pause {
                                // startにする
                                viewModel.updateState(to: .start)
                            }
                        }
                        // YES
                        Button("YES") {
                            viewModel.stopTimer()
                            // 設定画面に戻る
                            dismiss()
                        }
                    } message: {
                        Text("中断して前の画面に戻りますか？")
                    }  // .alertここまで
                }  // if isShowStopButtonここまで
            }  // VStackここまで
        }  // ZStack
#if DEBUG
        // 画面タップで終了
        .onTapGesture {
            viewModel.forceEndForDebug()
        }
#endif
        .onAppear {
            // 画面起動時にprestart状態にする
            viewModel.updateState(to: .preStart)
            // 画面起動時に瞑想前タイマー5秒をセットする
            viewModel.setFirstTimer()
        }
        .onChange(of: viewModel.state) {
            switch viewModel.state {
            case .preStart:
                // 瞑想前タイマーの呼出
                viewModel.startPreparationTimer()
            case .prePause:
                // タイマー停止・無効
                viewModel.stopTimer()
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .start:
                // 音再生タイマーの呼出
                viewModel.startMeditationTimer()
            case .pause:
                // タイマー停止・無効
                viewModel.stopTimer()
                // isShowAlertをtrue
                isShowStopAlert.toggle()
            case .end:
                // タイマー停止・無効
                viewModel.stopTimer()
                // 終了アラート表示
                isShowEndAlert.toggle()
            }
        }
        // 瞑想終了アラート
        .alert("終了", isPresented: $isShowEndAlert) {
            Button("OK") {
                // 保存メソッドを呼び出し
                viewModel.saveMeditationRecord()
                // 設定画面へ戻る
                dismiss()
            }
        } message: {
            Text("おつかれさまでした")
        }  // .alertここまで
    }  // bodyここまで
    // MARK: - Helper Methods
    /// 準備状態かどうか
    private var isPreparationState: Bool {
        viewModel.state == .preStart || viewModel.state == .prePause
    }
    /// 瞑想状態かどうか
    private var isMeditationState: Bool {
        viewModel.state == .start || viewModel.state == .pause
    }
    /// 中断ボタンアクション
    private func handleStopButtonAction() {
        switch viewModel.state {
        case .preStart:
            viewModel.updateState(to: .prePause)
        case .start:
            viewModel.updateState(to: .pause)
        default:
            break
        }
    }
    /// 中断アラートのNOボタンアクション
    private func handleStopAlertNoAction() {
        switch viewModel.state {
        case .prePause:
            viewModel.updateState(to: .preStart)
        case .pause:
            viewModel.updateState(to: .start)
        default:
            break
        }
    }
    /// 中断アラートのYESボタンアクション
    private func handleStopAlertYesAction() {
        viewModel.stopTimer()
        dismiss()
    }
    // fetchPreviewURL
    func fetchPreviewURL(for trackID: String) async {
        // エラーを出すメソッドを安全に返す(request)
        do {
            // Apple Musicの認証ステータス
            let musicAuthorizationStatus = await MusicAuthorization.request()
            // 認証されなかったら
            guard musicAuthorizationStatus == .authorized else {
                // アラート表示
//                isShowAlert = true
                // 処理終了　なにもしない
                print("許可されませんでした")
                return
            }  // guard musicAuthorizationStatus
            // 楽曲IDを指定してリクエストを作成
            let request = MusicCatalogResourceRequest<Song>(
                matching: \.id, equalTo: MusicItemID(trackID))
            // レスポンスを取得
            let response = try await request.response()
            // 曲とプレビューURLが存在する場合
            if let song = response.items.first,
                let previewURL = song.previewAssets?.first?.url
            {
                // previewURLに代入
                self.previewURL = previewURL
                print("previewURLの取得完了！")
            }  // if let
            // エラーの場合
        } catch {
            print("指定したトラックID（\(trackID)）の曲とpreviewURLがありません")
            print("エラーはこちら: \(error)")
            return
        }  // do catch
    }  // fetchPreviewURL
    // 曲を再生するメソッド
    private func playBack() {
        print("playBack1")
        // previewURL、fadeOutEndTimeが存在しなかったら
        guard let previewURL
//            let fadeOutEndTime
        else {
            print("previewURLが存在しません")
            print("playBack2")
            // 処理終了
            return
        }  // guard let
        // playerがnilのとき（初めての再生のとき）
        if audioPlayer == nil {
            print("playBack3")
            print("🙆新しいプレーヤーを取得しました！")
            // playerにpreviewUrlを代入する
            audioPlayer = AVPlayer(url: previewURL)
            // ボリュームを0に設定
//            audioPlayer?.volume = 0.0
            // 再生する
            audioPlayer?.play()
            print("playBack4")
            print("🍀プレイヤーの状態は\(String(describing: audioPlayer?.status.rawValue))")
            print("📣ボリュームは\(String(describing: audioPlayer?.volume))")
//            // フェードイン
//            fadeIn(player: audioPlayer!, duration: 5)
//            print("playBack5")
//        } else {
//            print("playBack6")
//            // 再開したとき
//            print("🌸一時停止した後の再開だよ！")
//            // 再生するのみ
//            audioPlayer?.play()
//            print("playBack7")
        }  // if player
//        print("playBack8")
//        // 多重にfadeOutEndTimerが実行されないようにする
//        stopTimer(timer: &fadeOutEndTimer)
//        print("playBack9")
//        // フェードアウトする時間を管理するタイマー
//        fadeOutEndTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//            print("playBack10")
//            // 現在時刻
//            let now = Date()
//            // fadeOutTimeはfadeOutEndTimeに向かって0.1秒スライスする　0と比較し、大きい値を格納
//            fadeOutTime = max(0, fadeOutEndTime.timeIntervalSince(now))
//            print("❤️フェードアウトのタイマーは\(fadeOutTime)")
//            // fadeOutTimeの5秒前になったら
//            if fadeOutTime >= 5 && fadeOutTime < 5.1 {
//                print("playBack11")
//                // 5秒かけてフェードアウト
//                fadeOut(player: audioPlayer!, duration: 5.0) {
//                    print("playBack12")
//                    fadeOutComplete()
//                    print("playBack13")
//                }
//            } else if fadeOutTime > 0 && fadeOutTime < 5 {
//                print("playBack14")
//                // 0 < fadeOutTime < 5 のとき
//                print(fadeOutTime)
//                // 残り時間をかけてフェードアウト
//                fadeOut(player: audioPlayer!, duration: fadeOutTime) {
//                    print("playBack15")
//                    fadeOutComplete()
//                    print("playBack16")
//                }
//            } else if fadeOutTime == 0 {
//                print("playBack17")
//                // fadeOutTimeが0のとき
//                // 処理なし
//                return
//            }  // if fadeOutTime...
//            print("playBack18")
//        }  // fadeOutEndTimer
//        print("🟢playBack19")
//        print("⭐️previewURLはこちら\(previewURL)")
    }  // func playBack()
}  // ContentViewここまで

struct MeditatingView_Previews: PreviewProvider {
    static var previews: some View {
        MeditatingView(viewModel: MeditatingSetViewModel())
    }
}
