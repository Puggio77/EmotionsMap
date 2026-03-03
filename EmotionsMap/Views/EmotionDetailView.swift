//
//  EmotionDetailView.swift
//  EmotionsMap
//
//  Model + data → SpecificEmotionItem.swift
//  Shell card UI → ShellCard.swift
//

import SwiftUI

struct EmotionDetailView: View {
    @EnvironmentObject private var router: AppRouter

    /// Tracks the centred card for the dot indicator
    @State private var currentIndex: Int = 0

    /// iOS 17 scroll position binding (optional Int keyed by index)
    @State private var scrollPosition: Int? = 0

    /// Set of indices whose name has been revealed by tapping
    @State private var revealed: Set<Int> = []

    /// Whether the current centred card is revealed (used for confirm button)
    private var currentIsRevealed: Bool { revealed.contains(currentIndex) }

    private var emotions: [SpecificEmotionItem] {
        emotionData[router.vm.moodLabel] ?? []
    }

    var body: some View {
        ZStack {
            Color(red: 129/255, green: 205/255, blue: 192/255).ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Header ──
                VStack(alignment: .leading, spacing: 6) {
                    Text("recognise your emotion")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)

                    Text(currentIsRevealed ? "this is how you feel — or keep exploring" : "tap the shell to reveal what's inside")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                        .animation(.easeInOut(duration: 0.2), value: currentIsRevealed)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .padding(.top, 28)
                .padding(.bottom, 20)

                // ── Shell Carousel ──
                GeometryReader { geo in
                    let cardWidth = geo.size.width * 0.72
                    let spacing: CGFloat = 24

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing) {
                            ForEach(Array(emotions.enumerated()), id: \.offset) { index, emotion in
                                ShellCard(
                                    emotion: emotion,
                                    isRevealed: revealed.contains(index),
                                    cardWidth: cardWidth
                                ) {
                                    tapShell(at: index)
                                }
                                .id(index)
                                .scrollTransition(.animated(.spring(response: 0.4, dampingFraction: 0.8))) { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.88)
                                        .opacity(phase.isIdentity ? 1.0 : 0.55)
                                }
                            }
                        }
                        .scrollTargetLayout()
                        .padding(.horizontal, (geo.size.width - cardWidth) / 2)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $scrollPosition)
                    .onChange(of: scrollPosition) { _, newVal in
                        if let i = newVal { currentIndex = i }
                    }
                }
                .frame(maxHeight: .infinity)

                // ── Dots + confirm button ──
                VStack(spacing: 16) {
                    // Dot indicators
                    HStack(spacing: 8) {
                        ForEach(emotions.indices, id: \.self) { i in
                            Circle()
                                .fill(i == currentIndex ? Color.white : Color.white.opacity(0.35))
                                .frame(width: i == currentIndex ? 10 : 7,
                                       height: i == currentIndex ? 10 : 7)
                                .animation(.spring(response: 0.3), value: currentIndex)
                        }
                    }

                    // Confirm button — only shown after the current shell is revealed
                    if currentIsRevealed, currentIndex < emotions.count {
                        Button {
                            let emotion = emotions[currentIndex]
                            router.vm.specificEmotion = emotion.name
                            var transaction = Transaction(animation: .default)
                            transaction.disablesAnimations = false
                            withTransaction(transaction) { router.checkInPage = 2 }
                        } label: {
                            Label("Choose \"\(emotions[currentIndex].name)\"", systemImage: "checkmark.circle.fill")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(.white)
                        .foregroundStyle(Color(red: 129/255, green: 205/255, blue: 192/255))
                        .padding(.horizontal, 28)
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                    } else {
                        Label("Tap the shell to reveal", systemImage: "hand.tap.fill")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
                            .transition(.opacity)
                    }
                }
                .padding(.bottom, 28)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentIsRevealed)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Interaction

    private func tapShell(at index: Int) {
        let gen = UIImpactFeedbackGenerator(style: .medium)
        gen.prepare()
        gen.impactOccurred()

        withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
            revealed.insert(index)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EmotionDetailView()
            .environmentObject({
                let r = AppRouter()
                r.vm.manualMoodLabel = "Energetic / Enthusiastic"
                return r
            }())
    }
}
