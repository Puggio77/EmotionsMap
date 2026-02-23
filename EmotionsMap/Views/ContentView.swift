//
//  ContentView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var reportStore = ReportStore()
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            IMImmersiveHomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .emotionSpectrum:
                        EmotionSpectrumView()
                    case .emotionDetail:
                        EmotionDetailView()
                    case .emotionCapture:
                        EmotionCaptureView()
                    case .archive:
                        IMPastReflectionsView()
                    }
                }
        }
        .environmentObject(reportStore)
        .environmentObject(router)
    }
}

#Preview {
    ContentView()
}
