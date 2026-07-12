# Breath Trip 

## 1. 概要
息（呼吸瞑想）しながら世界旅行ができる iOS アプリです。<br>
6 大陸・36 か所の環境音（Apple Music 経由）とタイマー、瞑想記録、地図表示、日本語の音声ガイドを組み合わせて「息のたび」を楽しめます。

## 2. ダウンロードリンク
[![App_Store_Badge_JP](https://user-images.githubusercontent.com/68992872/204145956-f5cc0fa8-d4c9-4f2c-b1d4-3c3b1d2e2aba.png)](https://testflight.apple.com/join/fZqxBBDm)

## 3. 実行画面

## 4. アプリの機能
### 瞑想

- 瞑想時間の選択（1 / 3 / 5 / 10 / 20 / 30 / 40 / 50 / 60 分）
- 大陸 → 地域（36 か所）の音源選択
- 5 秒の準備タイマー後、本番タイマーで瞑想
- 音声ガイド（ON/OFF）：呼吸・姿勢などの日本語ナレーション（`VOICEVOX:離途`）
- フェードイン / フェードアウト付きの BGM 再生
- 終了後、日付・瞑想時間・選択した「世界の音」の名前を Core Data に保存

### 音をきく

- 瞑想と同様に大陸・地域の音を選択
- タイマーのみで音を聴くモード（瞑想記録は行わない）
- Apple Music へのアクセスが必要

### カレンダー

- 月単位で瞑想記録を表示
- 日ごとの瞑想時間に応じてセルの背景色が変化（1〜20 分 / 21〜40 分 / 41 分以上）
- 前月・翌月への切り替え

### 地図

- MapKit で世界のスポットをピン表示
- 音源名と緯度経度を対応付けて表示

### 瞑想とは

- アプリの説明
- 「瞑想のやりかた」「瞑想の効果」「アプリの説明」画面へのナビゲーション

## 5. 音源データ

6 大陸 × 各地域 6 か所 = **36 種類**の音があります。

| 大陸 | 例（一部） |
|------|------------|
| ヨーロッパ | スイス、イタリア、フランス… |
| オセアニア | ニュージーランド、オーストラリア… |
| アジア | 日本、タイ、インド… |
| アフリカ | ケニア、エチオピア… |
| 北アメリカ | アメリカ、メキシコ… |
| 南アメリカ | ブラジル、コスタリカ… |

各音源は `SoundModel` の `fileName`（Apple Music のトラック ID）と紐づいています。
## 6. アプリのコンセプト

 <a href="https://speakerdeck.com/macchanmaccha/breathtrip-concept1-dot-2"><img alt="コンセプトスライド" src="https://github.com/user-attachments/files/29462990/BreathTrip_Concept1.2.pdf"></a>

## 7. 内部設計
<img width="1512" height="802" alt="flowchart" src="https://github.com/user-attachments/assets/cea2b95c-7aef-4e42-b6cb-1c5739616589" />

## 8. MVVMの構成
## 9. 工夫したコード／設計
### フェードイン・フェードアウトとタイマー管理
没入感を大事にするため、音の始まりと終わりを上品に聞こえるための設計を行いました。
瞑想アプリにおいて、音の開始・終了は「急に鳴る／急に止まる」体験をそのまま残してしまいます。本アプリでは、Apple Music の 30 秒プレビューという制約の中でも、セッション全体を途切れなく聴けるよう、**音量の指数カーブ制御**と**複数タイマーの役割分担**を組み合わせて実装しています。

### 背景と課題

- Apple Music のプレビュー音源は約 30 秒で終了する
- 瞑想時間は数分〜十数分と、プレビューの長さをはるかに超える
- 単純な線形フェードでは、音量変化が機械的に聞こえる
- 一時停止・中断・画面離脱など、タイマーと再生状態がずれやすい

### アーキテクチャ概要

タイマーとフェード処理は `SetViewModel` を基底クラスとし、瞑想画面（`MeditatingSetViewModel`）と音を聴く画面（`ListeningSetViewModel`）で共通ロジックを継承・オーバーライドしている。

| タイマー | 役割 |
|---|---|
| `selectedDurationMinutesTimer` | セッション残り時間のカウントダウン（0.1 秒間隔） |
| `fadeInTimer` | 再生開始時の音量フェードイン（0.1 秒刻み） |
| `fadeOutTimer` | 音量フェードアウト本体（0.1 秒刻み） |
| `fadeOutEndTimer` | プレビュー終了 5 秒前のフェードアウト開始を監視 |
| `preparationTimer` | 瞑想開始前の 5 秒カウントダウン（瞑想画面のみ） |

フェードの実行中かどうかは、`Timer.isValid` から導出する計算プロパティ（`isFadeIn` / `isFadeOut`）で判定し、**二重起動を防止**している。

### 1. 人間の耳に自然な音量カーブ（指数関数的フェード）

線形に音量を変えるのではなく、経過時間を 0〜1 に正規化したうえで **2 乗カーブ**を適用している。

- **フェードイン**: `volume = pow(t, 2)` — 序盤はゆっくり、後半で立ち上がる
- **フェードアウト**: `volume = startVolume × pow(1 - t, 2)` — 序盤は聴こえやすく、終盤で静かに消える

0.1 秒間隔（50 ステップ / 5 秒）で `AVPlayer.volume` を更新することで、急な音量変化を避けつつ、瞑想に集中しやすい聴感を実現している。

また、セッション時間が 10 秒以下の場合や、すでにフェード処理が走っている場合はフェードをスキップし、短時間設定でも破綻しないようガードしている。

### 2. 終了時刻ベースのタイマー設計（ドリフト・一時停止への耐性）

カウントダウンを「1 秒ずつ減算」する方式ではなく、**絶対時刻 `endTime` を基準**に残り時間を算出している。

```swift
endTime = Date().addingTimeInterval(remainingSeconds)
remainingSeconds = ceil(max(0, endTime.timeIntervalSince(Date())))


- **SwiftUI** — 画面・ナビゲーション
- **Core Data** — 瞑想記録（`MeditationInfo` エンティティ）
- **UserDefaults** — 音源名・分数・音声ガイド設定など（`UserDefaultsKey` で一元管理）
- **MusicKit** — Apple Music 楽曲の取得・再生
- **AVFoundation** — プレビュー再生、音声ガイド、オーディオセッション・割り込み対応
- **MapKit** — 地図とピン

### Core Data スキーマ

`MeditationInfo` エンティティ:

| 属性 | 型 | 説明 |
|------|-----|------|
| `date` | Date | 瞑想した日 |
| `meditationTime` | Int32 | 瞑想時間（分） |
| `worldSounds` | String | 選択した音源名（地域名） |

## プロジェクト構成

```
MeditationJourney/
├── MeditationJourneyApp.swift      # エントリポイント
├── Persistence.swift               # Core Data スタック
├── MeditationJourney.xcdatamodeld
├── Model/
│   ├── ContinentModel.swift
│   ├── SoundModel.swift
│   ├── SpotDataModel.swift
│   ├── SpotListModel.swift
│   ├── UserDefaultsKey.swift
│   └── MeditationAudioGuide.swift
├── ViewModel/
│   ├── SetViewModel.swift
│   ├── MeditatingSetViewModel.swift
│   ├── ListeningSetViewModel.swift
│   ├── CalendarViewModel.swift
│   └── SpotListViewModel.swift
├── View/
│   ├── HomeView/
│   ├── SelectContinentAndMusicView/
│   ├── PlayingView/
│   └── HowToView/
├── Extensions/
├── Resources/                      # 音声ガイド WAV
└── Assets.xcassets/
```

## 画面フロー

```
TabSetView
├── MeditationSetView → SelectContinentView → SelectSoundView → MeditatingView
├── ListeningSetView  → … → ListeningView
├── CalendarView
├── MapView
└── ExplanationView → WayOfMeditationView / EffectOfMeditationView / DescriptionView
```

## 開発環境

1. [Xcode](https://developer.apple.com/xcode/) で `MeditationJourney.xcodeproj` を開く
2. ターゲット **MeditationJourney** を選択
3. 実機またはシミュレータで Run（⌘R）

| 設定 | 値 |
|------|-----|
| Bundle Identifier | `rakuten.jp.tay.13-fearless.MeditationJourney` |
| Marketing Version | 1.0 |
| Deployment Target | iOS 26.4 |
| 対応デバイス | iPhone のみ |
| コード品質 | [SwiftLint](.swiftlint.yml) |
