//
//  MoodReport.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import Foundation

struct MoodReport: Identifiable, Codable, Equatable {
    let id: UUID
    let createdAt: Date

    // 0...1
    var x: Double
    var y: Double

    // derived / saved for convenience
    var moodLabel: String

    /// The specific emotion picked in EmotionDetailView (e.g. "Peaceful")
    var specificEmotion: String?

    var triggerText: String
    var isTriggerHidden: Bool
    /// Filename (not full path) of the recorded voice memo, if any
    var audioFileName: String?

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
