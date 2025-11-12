//
//  Persistence.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/10.
//

/*
 使用例:
 1. ViewModelでのCoreData操作:
 class SomeViewModel: ObservableObject {
 private let context = PersistenceController.shared.container.viewContext
 }
 
 2. SwiftUIプレビューで使用:
 #Preview {
 SomeView(viewModel: SomeViewModel())
 }
 
 3. MeditationJourneyApp.swiftでの初期化:
 @main
 struct MeditationJourneyApp: App {
 let persistenceController = PersistenceController.shared
 }
 */

import CoreData
/// CoreDataスタックを管理するコントローラー
struct PersistenceController {
    /// アプリ全体で共有するCoreDataインスタンス
    /// 使用例:PersistenceController.shared.container.viewContext
    static let shared = PersistenceController()
    /// SwiftUIプレビュー用のインメモリデータベース（サンプルデータ付き）
    /// 使用例: PersistenceController.preview.container.viewContext
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // プレビュー表示用に10件の瞑想記録サンプルを作成
        for i in 0..<10 {
            let newMeditationInfo = MeditationInfo(context: viewContext)
            // 日付: 今日から10日前まで（過去10日分）
            newMeditationInfo.date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            // 世界の音: 5つの異なる場所をローテーション
            let worldSounds = ["日本", "フランス", "タイ", "エジプト", "メキシコ"]
            newMeditationInfo.worldSounds = worldSounds[i % 5]
            // 瞑想時間: 5分から50分まで（5分刻み）
            newMeditationInfo.meditationTime = Int32((i + 1) * 5)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    /// MeditationJourney.xcdatamodeldを管理するCoreDataコンテナ
    let container: NSPersistentContainer
    /// CoreDataスタックを初期化（inMemory: テスト用メモリDB）
    init(inMemory: Bool = false) {
        // MeditationJourney.xcdatamodeldファイルを読み込んでコンテナ作成
        container = NSPersistentContainer(name: "MeditationJourney")
        if inMemory {
            // テスト・プレビュー用のメモリDBに設定
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        // 永続ストア（データベースファイル）を読み込み
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // 考えられる原因：ディスク容量不足、権限エラー、モデルバージョン不一致など
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // 親コンテキストからの変更を自動でマージ
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
