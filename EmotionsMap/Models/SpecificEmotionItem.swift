//
//  SpecificEmotionItem.swift
//  EmotionsMap
//

import Foundation

// MARK: - Model

struct SpecificEmotionItem: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let description: String

    static func items(for basicEmotion: BasicEmotion) -> [SpecificEmotionItem] {
        EmotionsData.all
            .filter { $0.basicEmotion == basicEmotion }
            .flatMap { $0.specificEmotions }
            .map { SpecificEmotionItem(name: $0.name, description: $0.description) }
    }
}
