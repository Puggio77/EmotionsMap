//
//  HomeView.swift
//  EmotionsMap
//
//  Created by Riccardo on 2026.
//  SpeechBubble component → Components/SpeechBubble.swift
//

import SwiftUI

// MARK: - Crab state

private enum CrabState {
    case closed       // HermitCrabSoloClosed — waiting
    case animating    // HermieAnimation sprite sheet playing once
    case open         // HermitCrabSoloOpen — fully awake
}

// MARK: - HomeView

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter

    @State private var crabState: CrabState = .closed
    @State private var dialogueStep = -1
    @State private var showButtons = false

    private let dialogLines = [
        "Hey there! 🦀\nI'm Hermie, your emotional guide!",
        "How are you feeling today?\nWant to explore your emotions?"
    ]

    var body: some View {
        ZStack {

            // ── Layer 1: Island background ──
            Image("Island")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // ── Layer 2: Crab — always centred, independent of UI ──
            // Frame: 2466/6 × 1890/6 = 411 × 315 → at width 280, height ≈ 215
            crabView
                .id(crabState)
                .frame(width: 280, height: 280 * 315 / 411)
                .onTapGesture {
                    guard crabState == .closed else { return }
                    wakeUpCrab()
                }

            // ── Layer 3: UI — speech bubbles top, buttons/hint bottom ──
            VStack(spacing: 0) {

                // TOP: Speech bubbles
                if crabState == .open && dialogueStep >= 0 {
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

                // BOTTOM: hint label or action buttons
                if crabState == .closed {
                    Label("Tap on Hermie or shake the phone to wake him up", systemImage: "hand.tap.fill")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.bottom, 50)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if crabState == .open && showButtons {
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
            guard crabState == .closed else { return }
            wakeUpCrab()
        }
        .onChange(of: router.shouldResetHomeFlow) { _, triggered in
            if triggered {
                withAnimation(.easeInOut(duration: 0.3)) {
                    crabState    = .closed
                    dialogueStep = -1
                    showButtons  = false
                }
                router.shouldResetHomeFlow = false
            }
        }
    }

    // MARK: - Crab view

    // HermieAnimation grid: 6 cols × 6 rows = 36 frames (indices 0–35)
    private let spriteRows = 6
    private let spriteCols = 6
    private var lastFrame: Int { spriteRows * spriteCols - 1 }  // 35

    @ViewBuilder
    private var crabView: some View {
        switch crabState {
        case .closed:
            // First frame of the sprite sheet
            SpriteAnimationView(
                imageName: "HermieAnimation",
                rows: spriteRows, cols: spriteCols,
                startFrame: 0
            )

        case .animating:
            // Play all frames once, then transition to open
            SpriteAnimationView(
                imageName: "HermieAnimation",
                rows: spriteRows, cols: spriteCols,
                fps: 12,
                startFrame: 0,
                playAnimation: true
            ) {
                transitionToOpen()
            }

        case .open:
            // Last frame of the sprite sheet
            SpriteAnimationView(
                imageName: "HermieAnimation",
                rows: spriteRows, cols: spriteCols,
                startFrame: lastFrame
            )
        }
    }

    // MARK: - Logic

    private func wakeUpCrab() {
        playWakeUpHaptics()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            crabState = .animating
        }
    }

    /// Called by SpriteAnimationView when the last frame is reached
    private func transitionToOpen() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            crabState = .open
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
