//
//  EmotionsMapApp.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI
import SwiftData

@main
struct EmotionsMapApp: App {
    @StateObject private var store = ReportStore()
    
    let container: ModelContainer = {
        let schema = Schema([
            SubEmotion.self,
            SpecificEmotion.self,
            Trigger.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                IMImmersiveHomeView()
            }
            .environmentObject(store)
            .modelContainer(container)
            .task {
                await MainActor.run {
                    EmotionsData.seed(into: container.mainContext)
                }
            }
        }
    }
}
