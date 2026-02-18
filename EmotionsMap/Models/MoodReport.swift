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

    var triggerText: String
    var isTriggerHidden: Bool

    init(id: UUID = UUID(),
         createdAt: Date = Date(),
         x: Double,
         y: Double,
         moodLabel: String,
         triggerText: String,
         isTriggerHidden: Bool) {
        self.id = id
        self.createdAt = createdAt
        self.x = x
        self.y = y
        self.moodLabel = moodLabel
        self.triggerText = triggerText
        self.isTriggerHidden = isTriggerHidden
    }
}
