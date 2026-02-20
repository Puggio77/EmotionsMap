//
//  ContentView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var reportStore = ReportStore()

    var body: some View {
        NavigationStack {
            IMImmersiveHomeView()
        }
        .environmentObject(reportStore)
    }
}

#Preview {
    ContentView()
}
