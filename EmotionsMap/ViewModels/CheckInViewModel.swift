//
//  CheckInViewModel.swift
//  EmotionsMap
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class CheckInViewModel: ObservableObject {

    /// Angle of the dragged pin in degrees. 0 = north/top, increases clockwise.
    @Published var pinAngle: Double = 0

    /// How intensely the emotion is felt: 0 = center (mild), 1 = edge (intense).
    @Published var pinIntensity: Double = 0

    /// The specific emotion name selected in EmotionDetailView (e.g. "Hopeful")
    @Published var specificEmotion: String? = nil

    @Published var triggerText: String = ""
    @Published var isTriggerHidden: Bool = false

    /// Filename (not full path) of a saved voice memo, if the user chose to record
    @Published var audioFileName: String? = nil

    // MARK: – Derived

    /// Which basic emotion the current pin angle maps to
    var basicEmotion: BasicEmotion {
        BasicEmotion.from(angle: pinAngle)
    }

    /// Island location name for the current emotion (used as moodLabel in reports)
    var moodLabel: String { basicEmotion.locationName }

    /// Intensity as a 0–1 value (alias exposed for consumers)
    var emotionIntensity: Double { pinIntensity }

    /// Cartesian x coordinate (0.5 = centre), preserved for MoodReport
    var x: Double { 0.5 + pinIntensity * 0.5 * sin(pinAngle * .pi / 180) }

    /// Cartesian y coordinate (0.5 = centre), preserved for MoodReport
    var y: Double { 0.5 - pinIntensity * 0.5 * cos(pinAngle * .pi / 180) }

    // MARK: – Actions

    func buildReport() -> MoodReport {
        MoodReport(
            x: x,
            y: y,
            moodLabel: moodLabel,
            specificEmotion: specificEmotion,
            triggerText: triggerText.trimmingCharacters(in: .whitespacesAndNewlines),
            isTriggerHidden: isTriggerHidden,
            audioFileName: audioFileName
        )
    }

    var canSave: Bool { true }
}
