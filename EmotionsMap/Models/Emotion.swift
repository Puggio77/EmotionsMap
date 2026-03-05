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

    /// The island location name shown in the UI
    var locationName: String {
        switch self {
        case .joy:       return "Beach of Joy"
        case .sadness:   return "Lake of Sadness"
        case .disgusted: return "Cave of Disgust"
        case .anger:     return "Volcano of Anger"
        case .fear:      return "Forest of Fear"
        case .surprise:  return "Garden of Surprise"
        }
    }

    /// Center angle of this emotion's circle sector (0 = north/top, clockwise)
    var sectorAngle: Double {
        switch self {
        case .joy:       return 0
        case .disgusted: return 60
        case .sadness:   return 120
        case .anger:     return 180
        case .fear:      return 240
        case .surprise:  return 300
        }
    }

    /// Returns the emotion whose sector contains the given angle.
    /// - Parameter angle: degrees, 0 = north/top, increases clockwise
    static func from(angle: Double) -> BasicEmotion {
        let ordered: [BasicEmotion] = [.joy, .disgusted, .sadness, .anger, .fear, .surprise]
        let idx = Int(((angle + 30).truncatingRemainder(dividingBy: 360)) / 60) % 6
        return ordered[max(0, min(5, idx))]
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
