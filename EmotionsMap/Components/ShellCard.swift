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
    let onTap: () -> Void

    private var shellName: String {
        let index = abs(emotion.name.hashValue) % 5 + 1
        return "shell_\(index)"
    }

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.15), radius: 16, y: 8)

            VStack(spacing: 24) {
                // Shell image — bounces on reveal
                Image(shellName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: cardWidth * 0.62, height: cardWidth * 0.62)
                    .scaleEffect(isRevealed ? 1.08 : 1.0)
                    .animation(.spring(response: 0.35, dampingFraction: 0.5), value: isRevealed)

                // Emotion name — revealed after tap
                if isRevealed {
                    VStack(spacing: 6) {
                        Text(emotion.name.lowercased())
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)

                        Text(emotion.description.lowercased())
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 12)
                    }
                    .transition(.scale(scale: 0.8, anchor: .top).combined(with: .opacity))
                } else {
                    Text("tap to reveal")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(.white.opacity(0.55))
                        .transition(.opacity)
                }
            }
            .padding(28)
        }
        .frame(width: cardWidth, height: cardWidth * 1.35)
        .contentShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .onTapGesture {
            if !isRevealed { onTap() }
        }
    }
}
