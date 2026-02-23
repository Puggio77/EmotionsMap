//
//  AppRouter.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 23/02/26.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Route enum

enum AppRoute: Hashable {
    case emotionSpectrum
    case emotionDetail
    case emotionCapture
    case archive
}

// MARK: - Router

@MainActor
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var vm = CheckInViewModel()
    @Published var shouldResetHomeFlow = false

    private var vmCancellable: AnyCancellable?

    init() {
        subscribeToVM()
    }

    // Forward every vm.objectWillChange to AppRouter.objectWillChange so
    // views observing the router (e.g. EmotionSpectrumView) re-render when
    // vm.x / vm.y / vm.moodLabel change.
    private func subscribeToVM() {
        vmCancellable = vm.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    func startCheckIn() {
        vm = CheckInViewModel()
        subscribeToVM()
        path.append(AppRoute.emotionSpectrum)
    }

    func openArchive() {
        path.append(AppRoute.archive)
    }

    func popToRoot() {
        path = NavigationPath()
        vm = CheckInViewModel()
        subscribeToVM()
        shouldResetHomeFlow = true
    }
}
