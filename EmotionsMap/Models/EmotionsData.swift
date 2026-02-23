//
//  EmotionsData.swift
//  EmotionsMap
//
//  Created by Leo A.Molina on 23/02/26.
//

import Foundation
import SwiftData

struct EmotionsData {
    
    static let all: [(subEmotion: String, basicEmotion: BasicEmotion, specificEmotions: [String])] = [
        
        // MARK: - Happy
        ("Playful",    .happy, ["Aroused", "Cheeky"]),
        ("Content",    .happy, ["Free", "Joyful"]),
        ("Interested", .happy, ["Curious", "Inquisitive"]),
        ("Proud",      .happy, ["Successful", "Confident"]),
        ("Accepted",   .happy, ["Respected", "Valued"]),
        ("Powerful",   .happy, ["Courageous", "Creative"]),
        ("Peaceful",   .happy, ["Loving", "Thankful"]),
        ("Trusting",   .happy, ["Sensitive", "Intimate"]),
        ("Optimistic", .happy, ["Hopeful", "Inspired"]),
        
        // MARK: - Sad
        ("Lonely",      .sad, ["Isolated", "Abandoned"]),
        ("Vulnerable",  .sad, ["Victimised", "Fragile"]),
        ("Despair",     .sad, ["Grief", "Powerless"]),
        ("Guilty",      .sad, ["Ashamed", "Remorseful"]),
        ("Depressed",   .sad, ["Empty", "Interior"]),
        ("Hurt",        .sad, ["Disappointed", "Embarrassed"]),
        
        // MARK: - Disgusted
        ("Repelled",      .disgusted, ["Hesitant", "Horrified"]),
        ("Awful",         .disgusted, ["Detestable", "Nauseated"]),
        ("Disappointed",  .disgusted, ["Revolted", "Appalled"]),
        ("Disapproving",  .disgusted, ["Embarrassed", "Judgmental"]),
        ("Critical",      .disgusted, ["Dismissive", "Sceptical"]),
        
        // MARK: - Angry
        ("Distant",    .angry, ["Numb", "Withdrawn"]),
        ("Critical",   .angry, ["Annoyed", "Infuriated"]),
        ("Frustrated", .angry, ["Hostile", "Provoked"]),
        ("Aggressive", .angry, ["Jealous", "Furious"]),
        ("Mad",        .angry, ["Violated", "Indignant"]),
        ("Bitter",     .angry, ["Ridiculed", "Disrespected"]),
        ("Humiliated", .angry, ["Resentful", "Betrayed"]),
        ("Let down",   .angry, ["Exposed", "Nervous"]),
        
        // MARK: - Fearful
        ("Scared",    .fearful, ["Helpless", "Frightened"]),
        ("Anxious",   .fearful, ["Overwhelmed", "Worried"]),
        ("Insecure",  .fearful, ["Inadequate", "Inferior"]),
        ("Weak",      .fearful, ["Worthless", "Insignificant"]),
        ("Rejected",  .fearful, ["Excluded", "Persecuted"]),
        ("Threatened",.fearful, ["Nervous", "Exposed"]),
        
        // MARK: - Bad
        ("Bored",       .bad, ["Indifferent", "Apathetic"]),
        ("Busy",        .bad, ["Pressured", "Rushed"]),
        ("Stressed",    .bad, ["Overwhelmed", "Out of control"]),
        ("Tired",       .bad, ["Sleepy", "Unfocused"]),
        
        // MARK: - Surprised
        ("Startled",      .surprised, ["Shocked", "Dismayed"]),
        ("Confused",      .surprised, ["Disillusioned", "Perplexed"]),
        ("Amazed",        .surprised, ["Astonished", "Awe"]),
        ("Excited",       .surprised, ["Eager", "Energetic"]),
    ]
    
    /// Call this once (e.g. on first launch) to seed the SwiftData store.
    @MainActor
    static func seed(into context: ModelContext) {
        // Avoid duplicate seeding
        let descriptor = FetchDescriptor<SubEmotion>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }
        
        for entry in all {
            let sub = SubEmotion(name: entry.subEmotion, basicEmotion: entry.basicEmotion)
            let specifics = entry.specificEmotions.map {
                SpecificEmotion(name: $0, basicEmotion: entry.basicEmotion)
            }
            sub.specificEmotions = specifics
            context.insert(sub)
            specifics.forEach { context.insert($0) }
        }
    }
}
