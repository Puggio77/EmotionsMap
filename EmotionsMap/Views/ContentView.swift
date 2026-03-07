//
//  ContentView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    let container: ModelContainer

    @StateObject private var reportStore: ReportStore
    @StateObject private var router = AppRouter()

    init(container: ModelContainer) {
        self.container = container
        _reportStore = StateObject(wrappedValue: ReportStore(modelContext: container.mainContext))
    }
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        Group {
            if hasSeenOnboarding {
                mainAppFlow
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: hasSeenOnboarding)
    }
    
    private var mainAppFlow: some View {
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
            router.checkInPage = 0
            router.shouldResetHomeFlow = true
        }) {
            CheckInFlowView()
                .environmentObject(router)
                .environmentObject(reportStore)
        }
        .environmentObject(reportStore)
        .environmentObject(router)
    }
}

// MARK: - Locked check-in flow

/// Hosts the three check-in pages inside a plain ZStack.
/// Pages advance only when the user completes the required action on each screen.
/// There is no swipe gesture — navigation is fully programmatic.
private struct CheckInFlowView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            switch router.checkInPage {
            case 0:
                EmotionMapIslandView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal:   .move(edge: .leading)
                    ))
            case 1:
                EmotionDetailView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal:   .move(edge: .leading)
                    ))
            case 2:
                EmotionCaptureView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal:   .move(edge: .leading)
                    ))
            default:
                EmptyView()
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.8), value: router.checkInPage)
        .background(Color(red: 155/255, green: 206/255, blue: 221/255).ignoresSafeArea())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MoodReport.self, configurations: config)
    return ContentView(container: container)
}
