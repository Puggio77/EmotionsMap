//
//  CheckInViewModel.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import Foundation
import Combine

@MainActor
final class CheckInViewModel: ObservableObject {
    // emotion point (0...1)
    @Published var x: Double = 0.5
    @Published var y: Double = 0.5

    /// The specific emotion name selected in EmotionDetailView
    @Published var specificEmotion: String? = nil
    
    /// Optional manual override for the mood label, bypassing x/y computation
    @Published var manualMoodLabel: String? = nil

    @Published var triggerText: String = ""
    @Published var isTriggerHidden: Bool = false
    /// Filename of a saved voice memo, if the user chose to record
    @Published var audioFileName: String? = nil

    var moodLabel: String {
        if let manual = manualMoodLabel {
            return manual
        }
        
        // mapping semplice (puoi raffinarlo)
        // x: valenza (sx negativo, dx positivo)
        // y: attivazione (giu bassa, su alta)
        switch (x, y) {
        case (0.0..<0.45, 0.55...1.0): return "Anxious / Tense"
        case (0.55...1.0, 0.55...1.0): return "Energetic / Enthusiastic"
        case (0.0..<0.45, 0.0..<0.45): return "Sad / Low"
        case (0.55...1.0, 0.0..<0.45): return "Calm / Relaxed"
        default: return "Neutral"
        }
    }

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

    var canSave: Bool {
        // consentiamo anche trigger vuoto, ma almeno emozione selezionata sempre ok
        true
    }
}
