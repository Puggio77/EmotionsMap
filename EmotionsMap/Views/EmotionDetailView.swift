//
//  EmotionDetailView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 23/02/26.
//

import SwiftUI

// MARK: - Model

struct SpecificEmotion: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
}

// MARK: - Data

private let emotionData: [String: [SpecificEmotion]] = [
    "Anxious / Tense": [
        SpecificEmotion(name: "Worried",    icon: "cloud.drizzle",       description: "A sense of ongoing concern about what might happen."),
        SpecificEmotion(name: "Nervous",    icon: "bolt",                description: "On edge, anticipating something difficult."),
        SpecificEmotion(name: "Stressed",   icon: "waveform.path",       description: "Overwhelmed by pressure from multiple directions."),
        SpecificEmotion(name: "Fearful",    icon: "eye.slash",           description: "A strong reaction to a perceived threat."),
        SpecificEmotion(name: "Uneasy",     icon: "questionmark.circle", description: "Something feels off, but you can't quite name it.")
    ],
    "Energetic / Enthusiastic": [
        SpecificEmotion(name: "Excited",    icon: "star.fill",           description: "A surge of positive energy looking forward to something."),
        SpecificEmotion(name: "Joyful",     icon: "sun.max.fill",        description: "A warm, uplifting feeling of happiness."),
        SpecificEmotion(name: "Motivated",  icon: "flame.fill",          description: "Driven and ready to take on challenges."),
        SpecificEmotion(name: "Inspired",   icon: "lightbulb.fill",      description: "Filled with creative energy and new ideas."),
        SpecificEmotion(name: "Proud",      icon: "trophy.fill",         description: "Satisfaction from an achievement or growth.")
    ],
    "Sad / Low": [
        SpecificEmotion(name: "Sad",        icon: "cloud.rain.fill",     description: "A heavy feeling, as if carrying extra weight."),
        SpecificEmotion(name: "Lonely",     icon: "person",              description: "Disconnected from others, longing for connection."),
        SpecificEmotion(name: "Hopeless",   icon: "moon.zzz",            description: "Finding it hard to see a way forward."),
        SpecificEmotion(name: "Bored",      icon: "minus.circle",        description: "Understimulated, waiting for something to change."),
        SpecificEmotion(name: "Apathetic",  icon: "arrow.down",          description: "Lacking energy or interest in everything around you.")
    ],
    "Calm / Relaxed": [
        SpecificEmotion(name: "Peaceful",   icon: "leaf.fill",           description: "A quiet, settled feeling with no urgency."),
        SpecificEmotion(name: "Content",    icon: "house.fill",          description: "Comfortable with things exactly as they are."),
        SpecificEmotion(name: "Grateful",   icon: "heart.fill",          description: "Appreciating what is present in your life."),
        SpecificEmotion(name: "Serene",     icon: "water.waves",         description: "A deep, undisturbed sense of quiet."),
        SpecificEmotion(name: "Relieved",   icon: "checkmark.circle.fill", description: "Tension has lifted after something stressful passed.")
    ],
    "Neutral": [
        SpecificEmotion(name: "Indifferent", icon: "equal.circle",   description: "Neither positive nor negative — just present."),
        SpecificEmotion(name: "Uncertain",   icon: "questionmark",   description: "Not sure what you are feeling yet."),
        SpecificEmotion(name: "Pensive",     icon: "bubble.left",    description: "Reflective and thoughtful, processing quietly."),
        SpecificEmotion(name: "Mixed",       icon: "shuffle",        description: "Several emotions at once, hard to pin down one.")
    ]
]

// MARK: - View

struct EmotionDetailView: View {

    @EnvironmentObject private var router: AppRouter

    @State private var selected: SpecificEmotion? = nil

    private var emotions: [SpecificEmotion] {
        emotionData[router.vm.moodLabel] ?? []
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // ── Header ───────────────────────────────────────────
                VStack(spacing: 6) {
                    Text("You're feeling")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(router.vm.moodLabel)
                        .font(.title2.weight(.bold))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal)

                // ── Prompt ───────────────────────────────────────────
                Text("Which of these fits best?")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // ── Emotion cards ────────────────────────────────────
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 14
                ) {
                    ForEach(emotions) { emotion in
                        EmotionCard(
                            emotion: emotion,
                            isSelected: selected?.id == emotion.id
                        )
                        .onTapGesture {
                            let newSelection: SpecificEmotion? = (selected?.id == emotion.id) ? nil : emotion
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selected = newSelection
                            }
                            router.vm.specificEmotion = newSelection?.name
                        }
                    }
                }
                .padding(.horizontal)

                // ── Description panel ────────────────────────────────
                if let emotion = selected {
                    VStack(alignment: .leading, spacing: 8) {
                        Label(emotion.name, systemImage: emotion.icon)
                            .font(.title3.weight(.semibold))
                        Text(emotion.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // ── Continue ─────────────────────────────────────────
                Button {
                    router.path.append(AppRoute.emotionCapture)
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(selected == nil)
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .padding(.top, 12)
        }
        .navigationTitle("Your Emotion")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Card

private struct EmotionCard: View {
    let emotion: SpecificEmotion
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: emotion.icon)
                .font(.system(size: 32))
                .foregroundStyle(isSelected ? .white : .primary)
            Text(emotion.name)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(isSelected ? .white : .primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(isSelected
                      ? Color.accentColor
                      : Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(
                    isSelected ? Color.accentColor : Color(.separator),
                    lineWidth: isSelected ? 0 : 1
                )
        )
        .scaleEffect(isSelected ? 1.04 : 1.0)
        .shadow(color: isSelected ? Color.accentColor.opacity(0.35) : .clear, radius: 8, y: 4)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EmotionDetailView()
            .environmentObject(AppRouter())
    }
}
