//
//  Persistence.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/10.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // サンプルデータを10件作成
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
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            //            You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MeditationJourney")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                //                You should not use this function in a shipping application,
                //                although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection
                 when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
