//
//  HomeView.swift
//  EmotionsMap
//
//  Created by Riccardo on 2026.
//  SpeechBubble component → Components/SpeechBubble.swift
//

import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter

    @State private var isCrabOpen = false
    @State private var dialogueStep = -1     // -1 = not started
    @State private var showButtons = false

    private let dialogLines = [
        "Hey there! 🦀\nI'm Hermie, your emotional guide!",
        "How are you feeling today?\nWant to explore your emotions?"
    ]

    var body: some View {
        ZStack {

            // ── Fullscreen crab background ──
            Image(isCrabOpen ? "HermitCarbIslandOpen" : "HermitCrabIslandClosed")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: isCrabOpen)
                .onTapGesture {
                    handleCrabTap()
                }

            // ── Main overlay: bubbles top, buttons bottom ──
            VStack {

                // ── TOP: Speech bubbles ──
                if isCrabOpen && dialogueStep >= 0 {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(0...min(dialogueStep, dialogLines.count - 1), id: \.self) { idx in
                            SpeechBubble(text: dialogLines[idx])
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.85, anchor: .bottomLeading)
                                        .combined(with: .opacity),
                                    removal: .opacity
                                ))
                                .id(idx)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                Spacer()

                // ── BOTTOM: Sleeping hint or action buttons ──
                if !isCrabOpen {
                    Label("Tap on Hermie or shake the phone to wake him up", systemImage: "hand.tap.fill")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.bottom, 50)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if isCrabOpen && showButtons {
                    VStack(spacing: 12) {
                        Button {
                            router.startCheckIn()
                        } label: {
                            Label("Register a new emotion", systemImage: "plus.circle.fill")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(.teal)

                        Button {
                            router.openArchive()
                        } label: {
                            Label("See past emotions", systemImage: "calendar.badge.clock")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .tint(.teal)
                    }
                    .padding(20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
        .onShake {
            if !isCrabOpen { wakeUpCrab() }
        }
        .onChange(of: router.shouldResetHomeFlow) { _, triggered in
            if triggered {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isCrabOpen = false
                    dialogueStep = -1
                    showButtons = false
                }
                router.shouldResetHomeFlow = false
            }
        }
    }

    // MARK: - Logic

    private func handleCrabTap() {
        if !isCrabOpen {
            wakeUpCrab()
        } else if !showButtons {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showButtons = true
            }
        }
    }

    private func wakeUpCrab() {
        playWakeUpHaptics()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isCrabOpen = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                dialogueStep = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                dialogueStep = 1
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showButtons = true
            }
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
