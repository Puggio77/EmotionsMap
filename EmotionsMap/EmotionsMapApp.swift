//
//  EmotionsMapApp.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI

@main
struct EmotionsMapApp: App {
    @StateObject private var store = ReportStore()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .environmentObject(store)
        }
    }
}
