//
//  Emotion.swift
//  EmotionsMap
//
//  Created by Leo A.Molina on 23/02/26.
//

import Foundation
import SwiftData

// First layer of Plutchik’s Wheel of Emotions
enum BasicEmotion: String, CaseIterable, Identifiable {
    
    case happy = "Happy"
    case sad = "Sad"
    case disgusted = "Disgusted"
    case angry = "Angry"
    case fearful = "Fearful"
    case bad = "Bad"
    case surprised = "Surprised"
    
    var id: Self { self }
    var hexColor: String {
        switch self {
        case .happy:     return "F9C74F" // Warm yellow
        case .sad:       return "4A90D9" // Muted blue
        case .disgusted: return "6BAB6E" // Murky green
        case .angry:     return "E63946" // Bold red
        case .fearful:   return "9B5DE5" // Deep purple
        case .bad:       return "F4845F" // Dull orange
        case .surprised: return "F7B2BD" // Soft pink
        }
    }
}

// Second layer of Plutchik’s Wheel of Emotions
@Model
class SubEmotion {
    
    var name: String
    var basicEmotion: BasicEmotion
    
    @Relationship(deleteRule: .cascade)
    var specificEmotions: [SpecificEmotion]?
    
    init(name: String = "Accepted", basicEmotion: BasicEmotion = .happy) {
        self.name = name
        self.basicEmotion = basicEmotion
    }
}

// Third layer of Plutchik’s Wheel of Emotions
@Model
class SpecificEmotion {
    var name: String
    var shellType: String
    var basicEmotion: BasicEmotion
    
    init(name: String = "Respected", basicEmotion: BasicEmotion = .happy) {
        self.name = name
        self.basicEmotion = basicEmotion
    }
}
