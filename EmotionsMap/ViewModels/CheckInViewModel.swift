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

    @Published var triggerText: String = ""
    @Published var isTriggerHidden: Bool = false

    var moodLabel: String {
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
            triggerText: triggerText.trimmingCharacters(in: .whitespacesAndNewlines),
            isTriggerHidden: isTriggerHidden
        )
    }

    var canSave: Bool {
        // consentiamo anche trigger vuoto, ma almeno emozione selezionata sempre ok
        true
    }
}
