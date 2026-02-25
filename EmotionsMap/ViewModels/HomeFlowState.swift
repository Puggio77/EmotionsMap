//
//  HomeFlowState.swift
//  EmotionsMap
//
//  Created by Riccardo on 2026.
//

import SwiftUI
import Combine

class HomeFlowState: ObservableObject {
    enum Step {
        case sleeping
        case askFeeling
        case askReflect
    }

    @Published var step: Step = .sleeping
    @Published var message: String = ""

    func wakeUp() {
        step = .askFeeling
        message = "How are you feeling today?"
    }

    func chooseNotNow() {
        step = .askReflect
        message = "Do you want to see your past reflections instead?"
    }
}
