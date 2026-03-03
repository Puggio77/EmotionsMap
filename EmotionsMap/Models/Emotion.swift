//
//  Emotion.swift
//  EmotionsMap
//
//  Created by Leo A.Molina on 23/02/26.
//

import Foundation
import SwiftData

// Core emotions based on the Junto Emotion Wheel
enum BasicEmotion: String, Codable, CaseIterable, Identifiable {

    case joy       = "Joy"
    case sadness   = "Sadness"
    case disgusted = "Disgusted"
    case anger     = "Anger"
    case fear      = "Fear"
    case surprise  = "Surprise"

    var id: Self { self }
    var hexColor: String {
        switch self {
        case .joy:       return "F9C74F" // Warm yellow
        case .sadness:   return "4A90D9" // Muted blue
        case .disgusted: return "6BAB6E" // Murky green
        case .anger:     return "E63946" // Bold red
        case .fear:      return "F4845F" // Dull orange
        case .surprise:  return "9B5DE5" // Deep purple
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
    
    init(name: String = "Happy", basicEmotion: BasicEmotion = .joy) {
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
    var emotionDescription: String

    init(name: String = "Hopeful", shellType: String = "None", basicEmotion: BasicEmotion = .joy, emotionDescription: String = "") {
        self.name = name
        self.shellType = shellType
        self.basicEmotion = basicEmotion
        self.emotionDescription = emotionDescription
    }
}
