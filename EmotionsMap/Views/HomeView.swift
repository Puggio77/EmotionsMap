//
//  HomeView.swift
//  EmotionsMap
//
//  Created by Riccardo on 2026.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    
    // Track whether the crab is open or closed
    @State private var isCrabOpen = false
    
    var body: some View {
        ZStack {
            // Background Image
            Image(isCrabOpen ? "hermit_crab_open" : "hermit_crab_closed")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onTapGesture {
                    if !isCrabOpen {
                        playWakeUpHaptics()
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isCrabOpen = true
                        }
                    }
                }
            
            // Instruction prompt if sleeping
            if !isCrabOpen {
                VStack {
                    Spacer()
                    Text("Tap the shell or shake the phone to wake up the hermit crab")
                        .font(.subheadline)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.bottom, 60)
                }
            }
            
            // Interaction UI after crab is open
            if isCrabOpen {
                VStack {
                    Spacer()
                    VStack(spacing: 18) {
                        Text("What would you like to do?")
                            .multilineTextAlignment(.center)
                            .font(.callout)
                            .foregroundStyle(.primary)

                        buttons
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .padding()
                    .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarHidden(true)
        .onShake {
            if !isCrabOpen {
                playWakeUpHaptics()
                withAnimation(.easeInOut(duration: 0.3)) {
                    isCrabOpen = true
                }
            }
        }
        // Reset flow to sleeping when returning home via router.popToRoot()
        .onChange(of: router.shouldResetHomeFlow) { _, triggered in
            if triggered {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isCrabOpen = false
                }
                router.shouldResetHomeFlow = false
            }
        }
    }
    
    @ViewBuilder
    private var buttons: some View {
        VStack(spacing: 12) {
            Button("Register a new emotion") {
                router.startCheckIn()
            }
            .buttonStyle(.borderedProminent)

            Button("See past emotions") {
                router.openArchive()
            }
            .buttonStyle(.bordered)
        }
    }
    
    private func playWakeUpHaptics() {
        Task {
            for _ in 0..<3 {
                await MainActor.run {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                try? await Task.sleep(nanoseconds: 150_000_000)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(AppRouter())
    }
}
