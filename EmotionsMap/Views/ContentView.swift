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
            HomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .archive:
                        PastReflectionsView()
                    default:
                        EmptyView()
                    }
                }
        }
        .sheet(isPresented: $router.isCheckInPresented, onDismiss: {
            router.shouldResetHomeFlow = true
        }) {
            TabView(selection: $router.checkInPage) {
                EmotionMapIslandView()
                    .tag(0)
                EmotionDetailView()
                    .tag(1)
                EmotionCaptureView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .ignoresSafeArea(edges: .bottom)
            .background(Color(red: 0.45, green: 0.78, blue: 0.72).ignoresSafeArea())
            .environmentObject(router)
            .environmentObject(reportStore)
        }
        .environmentObject(reportStore)
        .environmentObject(router)
    }
}

#Preview {
    ContentView()
}
