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

    /// Shore images — one per card, cycling mod 3
    private let shoreImages = ["shore 1", "shore 2", "shore 3"]
    private var shoreIndex: Int { currentIndex % shoreImages.count }

    /// Set of indices whose name has been revealed by tapping
    @State private var revealed: Set<Int> = []

    /// Whether the current centred card is revealed (used for confirm button)
    private var currentIsRevealed: Bool { revealed.contains(currentIndex) }

    private var emotions: [SpecificEmotionItem] {
        SpecificEmotionItem.items(for: router.vm.basicEmotion)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // ── Shore background — changes with scroll ──
            ZStack {
                ForEach(0..<shoreImages.count, id: \.self) { i in
                    Image(shoreImages[i])
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .opacity(i == shoreIndex ? 1 : 0)
                        .animation(.easeInOut(duration: 1.0), value: shoreIndex)
                }
            }
            .ignoresSafeArea()

            // ── Header overlay (top-left) ──
            VStack(alignment: .leading, spacing: 6) {
                Text("recognise your emotion")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Color(red: 0.35, green: 0.28, blue: 0.24))

                Text(currentIsRevealed ? "this is how you feel — or keep exploring" : "tap the shell to reveal what's inside")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.34))
                    .animation(.easeInOut(duration: 0.2), value: currentIsRevealed)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, 28)
            .padding(.top, 28)

            // ── Shell carousel + confirm button pinned to bottom ──
            VStack(spacing: 16) {
                GeometryReader { geo in
                    let cardWidth = geo.size.width * 0.50
                    let spacing: CGFloat = 20

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing) {
                            ForEach(Array(emotions.enumerated()), id: \.offset) { index, emotion in
                                ShellCard(
                                    emotion: emotion,
                                    isRevealed: revealed.contains(index),
                                    cardWidth: cardWidth,
                                    color: Color(router.vm.basicEmotion.hexColor)
                                ) {
                                    tapShell(at: index)
                                }
                                .id(index)
                            }
                        }
                        .scrollTargetLayout()
                        .padding(.horizontal, (geo.size.width - cardWidth) / 2)
                    }
                    .scrollClipDisabled()
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $scrollPosition)
                    .onChange(of: scrollPosition) { _, newVal in
                        if let i = newVal {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.72)) {
                                revealed.removeAll()
                            }
                            currentIndex = i
                        }
                    }
                }
                .frame(height: 260)

                // ── Confirm button ──
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
                    .tint(Color(red: 0.35, green: 0.28, blue: 0.24))
                    .foregroundStyle(Color(red: 241/255, green: 228/255, blue: 211/255))
                    .padding(.horizontal, 28)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
            .padding(.bottom, 32)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentIsRevealed)
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
