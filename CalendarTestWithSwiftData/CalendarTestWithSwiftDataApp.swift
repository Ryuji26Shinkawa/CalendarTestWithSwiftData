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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
//            ContentView()
            Home()
        }
        .modelContainer(sharedModelContainer)
    }
}
