//
//  HomeViewModel.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var isAwake: Bool = false

    var greeting: String {
        isAwake ? "Hi! How are you feeling?" : "Tap the avatar to wake it up"
    }

    func wakeUp() {
        isAwake = true
    }
}
