//
//  CalendarTestWithSwiftDataApp.swift
//  CalendarTestWithSwiftData
//
//  Created by 新川竜司 on 2025/02/11.
//

import SwiftUI
import SwiftData

@main
struct CalendarTestWithSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            Home()
//              .modelContainer(sharedModelContainer)
                .modelContainer(for: [TaskMetaData.self ,Task.self])
        }
    }
}

// なぜかこの設定↓だと動かない
var sharedModelContainer: ModelContainer = {
    // 1. Model 定義の型情報で Schema を初期化
    let schema = Schema([
        TaskMetaData.self,
        Task.self
    ])
    // 2. Schema で ModelConfiguration を初期化
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    // 3. ModelConfiguration で ModelContainer で初期化
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
