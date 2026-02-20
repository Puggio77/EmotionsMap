//
//  IMFlowState.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 20/02/26.
//


import Foundation
import Combine

@MainActor
final class IMFlowState: ObservableObject {

    enum Step: Equatable {
        case sleeping
        case askFeeling
        case askReflect
        case goToRecord
        case goToHistory
    }

    @Published var step: Step = .sleeping
    @Published var message: String = ""

    func wakeUp() {
        step = .askFeeling
        message = "How are you feeling today?"
    }

    func chooseRecord() {
        step = .goToRecord
    }

    func chooseNotNow() {
        step = .askReflect
        message = "Would you like to revisit your previous reflections?"
    }

    func chooseHistory() {
        step = .goToHistory
    }
}
