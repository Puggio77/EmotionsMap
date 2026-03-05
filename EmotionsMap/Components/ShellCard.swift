//
//  ShellCard.swift
//  EmotionsMap
//

import SwiftUI

// MARK: - Shell Card

struct ShellCard: View {
    let emotion: SpecificEmotionItem
    let isRevealed: Bool
    let cardWidth: CGFloat
    let color: Color
    let onTap: () -> Void

    @State private var randomOffset: CGSize = .zero
    @State private var randomRotation: Double = .zero
    @State private var randomScale: CGFloat = 1.0

    // Saved originals — used to restore after scroll resets the card
    @State private var savedOffset: CGSize = .zero
    @State private var savedRotation: Double = .zero
    @State private var savedScale: CGFloat = 1.0

    private var shellName: String {
        let index = abs(emotion.name.hashValue) % 5 + 1
        return "shell_\(index)"
    }

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                // Shell image — bounces on reveal
                ColoredShell(shellName: shellName, color: color)
                    .scaledToFit()
                    .frame(width: cardWidth * 0.60, height: cardWidth * 0.60)
                    .rotationEffect(.degrees(randomRotation)) // Apply rotation ONLY to the shell
                    .scaleEffect(isRevealed ? 1.08 : 1.0)
                    .animation(.spring(response: 0.35, dampingFraction: 0.5), value: isRevealed)

                // Emotion name — revealed after tap
                if isRevealed {
                    VStack(spacing: 8) {
                        Text(emotion.name.lowercased())
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundStyle(Color(red: 0.35, green: 0.28, blue: 0.24))

                        Text(emotion.description.lowercased())
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(Color(red: 0.35, green: 0.28, blue: 0.24).opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .transition(.scale(scale: 0.8, anchor: .top).combined(with: .opacity))
                } else {
                    Label("Tap the shell to reveal", systemImage: "hand.tap.fill")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.34))
                        .transition(.opacity)
                }
            }
            .padding(16)
            .scaleEffect(randomScale)
            .offset(randomOffset)
            .onChange(of: isRevealed) { _, nowRevealed in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.72)) {
                    if nowRevealed {
                        // Fly to center, slightly above
                        randomOffset = CGSize(width: 0, height: -50)
                        randomRotation = 0
                        randomScale = 1.0
                    } else {
                        // Restore original scattered position
                        randomOffset = savedOffset
                        randomRotation = savedRotation
                        randomScale = savedScale
                    }
                }
            }
        }
        .frame(width: cardWidth, height: cardWidth * 1.35)
        .contentShape(Rectangle()) // Easier tapping now that the rounded rect is gone
        .onAppear {
            // Pick a consistent random offset/rotation based on the emotion hash to keep it stable across rerenders
            let seed = abs(emotion.name.hashValue)
            // Random angle between -25 and +25 degrees
            let angle = Double((seed % 50) - 25)
            // Random offset within a much larger box: [-80, 80] for x and y
            let dx = CGFloat((seed % 160) - 80)
            let dy = CGFloat(((seed / 10) % 180) - 90)

            // Random scale between 0.75 and 1.15
            let scale = 0.75 + CGFloat(seed % 40) / 100.0
            
            randomRotation   = angle
            randomOffset      = CGSize(width: dx, height: dy)
            randomScale       = scale
            savedRotation     = angle
            savedOffset       = CGSize(width: dx, height: dy)
            savedScale        = scale
        }
        .contentShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .onTapGesture {
            if !isRevealed { onTap() }
        }
    }
}
