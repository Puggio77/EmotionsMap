//
//  MoodReport.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import Foundation
import SwiftData

@Model
final class MoodReport {
    var id: UUID
    var createdAt: Date

    // 0...1
    var x: Double
    var y: Double

    var moodLabel: String

    /// The specific emotion picked in EmotionDetailView (e.g. "Peaceful")
    var specificEmotion: String?

    var triggerText: String
    var isTriggerHidden: Bool

    /// Filename (not full path) of the recorded voice memo, if any
    var audioFileName: String?

    /// Derived from `moodLabel` — computed, not persisted by SwiftData
    var basicEmotion: BasicEmotion {
        switch moodLabel {
        case "Anxious / Tense":          return .fear
        case "Energetic / Enthusiastic": return .joy
        case "Sad / Low":                return .sadness
        case "Calm / Relaxed":           return .joy
        default:                         return .surprise
        }
    }

    init(id: UUID = UUID(),
         createdAt: Date = Date(),
         x: Double,
         y: Double,
         moodLabel: String,
         specificEmotion: String? = nil,
         triggerText: String,
         isTriggerHidden: Bool,
         audioFileName: String? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.x = x
        self.y = y
        self.moodLabel = moodLabel
        self.specificEmotion = specificEmotion
        self.triggerText = triggerText
        self.isTriggerHidden = isTriggerHidden
        self.audioFileName = audioFileName
    }
}
