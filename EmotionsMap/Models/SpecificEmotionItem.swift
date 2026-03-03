//
//  SpecificEmotionItem.swift
//  EmotionsMap
//

import Foundation

// MARK: - Model

struct SpecificEmotionItem: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
}

// MARK: - Data

let emotionData: [String: [SpecificEmotionItem]] = [
    "Anxious / Tense": [
        SpecificEmotionItem(name: "Worried",    icon: "cloud.drizzle",       description: "A sense of ongoing concern about what might happen."),
        SpecificEmotionItem(name: "Nervous",    icon: "bolt",                description: "On edge, anticipating something difficult."),
        SpecificEmotionItem(name: "Stressed",   icon: "waveform.path",       description: "Overwhelmed by pressure from multiple directions."),
        SpecificEmotionItem(name: "Fearful",    icon: "eye.slash",           description: "A strong reaction to a perceived threat."),
        SpecificEmotionItem(name: "Uneasy",     icon: "questionmark.circle", description: "Something feels off, but you can't quite name it.")
    ],
    "Energetic / Enthusiastic": [
        SpecificEmotionItem(name: "Excited",    icon: "star.fill",           description: "A surge of positive energy looking forward to something."),
        SpecificEmotionItem(name: "Joyful",     icon: "sun.max.fill",        description: "A warm, uplifting feeling of happiness."),
        SpecificEmotionItem(name: "Motivated",  icon: "flame.fill",          description: "Driven and ready to take on challenges."),
        SpecificEmotionItem(name: "Inspired",   icon: "lightbulb.fill",      description: "Filled with creative energy and new ideas."),
        SpecificEmotionItem(name: "Proud",      icon: "trophy.fill",         description: "Satisfaction from an achievement or growth.")
    ],
    "Sad / Low": [
        SpecificEmotionItem(name: "Sad",        icon: "cloud.rain.fill",     description: "A heavy feeling, as if carrying extra weight."),
        SpecificEmotionItem(name: "Lonely",     icon: "person",              description: "Disconnected from others, longing for connection."),
        SpecificEmotionItem(name: "Hopeless",   icon: "moon.zzz",            description: "Finding it hard to see a way forward."),
        SpecificEmotionItem(name: "Bored",      icon: "minus.circle",        description: "Understimulated, waiting for something to change."),
        SpecificEmotionItem(name: "Apathetic",  icon: "arrow.down",          description: "Lacking energy or interest in everything around you.")
    ],
    "Calm / Relaxed": [
        SpecificEmotionItem(name: "Peaceful",   icon: "leaf.fill",           description: "A quiet, settled feeling with no urgency."),
        SpecificEmotionItem(name: "Content",    icon: "house.fill",          description: "Comfortable with things exactly as they are."),
        SpecificEmotionItem(name: "Grateful",   icon: "heart.fill",          description: "Appreciating what is present in your life."),
        SpecificEmotionItem(name: "Serene",     icon: "water.waves",         description: "A deep, undisturbed sense of quiet."),
        SpecificEmotionItem(name: "Relieved",   icon: "checkmark.circle.fill", description: "Tension has lifted after something stressful passed.")
    ],
    "Neutral": [
        SpecificEmotionItem(name: "Indifferent", icon: "equal.circle",   description: "Neither positive nor negative — just present."),
        SpecificEmotionItem(name: "Uncertain",   icon: "questionmark",   description: "Not sure what you are feeling yet."),
        SpecificEmotionItem(name: "Pensive",     icon: "bubble.left",    description: "Reflective and thoughtful, processing quietly."),
        SpecificEmotionItem(name: "Mixed",       icon: "shuffle",        description: "Several emotions at once, hard to pin down one.")
    ]
]
