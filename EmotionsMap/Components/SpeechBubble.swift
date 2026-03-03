//
//  SpeechBubble.swift
//  EmotionsMap
//

import SwiftUI

// MARK: - Speech Bubble

struct SpeechBubble: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(text)
                .font(.system(.body, design: .rounded, weight: .semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.regularMaterial)
                )

            // Tail pointing down toward the crab
            HStack {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.regularMaterial)
                    .padding(.leading, 28)
                Spacer()
            }
            .offset(y: -4)
        }
    }
}
