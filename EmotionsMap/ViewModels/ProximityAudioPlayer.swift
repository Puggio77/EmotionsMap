//
//  ProximityAudioPlayer.swift
//  EmotionsMap
//

import Foundation
import AVFoundation
import UIKit
import Combine

// MARK: - Proximity-aware ear playback

/// Plays a saved recording through the earpiece when the phone is held near the ear.
/// Call `activate(fileName:)` when the audio panel becomes visible,
/// and `deactivate()` when it disappears.
@MainActor
final class ProximityAudioPlayer: NSObject, ObservableObject {

    @Published var isPlaying: Bool = false
    @Published var errorMessage: String? = nil

    private var player: AVAudioPlayer?
    private var fileName: String?

    // MARK: - Lifecycle

    func activate(fileName: String) {
        self.fileName = fileName
        UIDevice.current.isProximityMonitoringEnabled = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(proximityChanged),
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil
        )
    }

    func deactivate() {
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil
        )
        stopPlayback()
    }

    // MARK: - Proximity handler

    @objc private func proximityChanged() {
        if UIDevice.current.proximityState {
            startEarpiecePlayback()
        } else {
            stopPlayback()
        }
    }

    // MARK: - Playback

    private func startEarpiecePlayback() {
        guard let fileName else { return }
        let url = VoiceRecorder.documentsURL(for: fileName)
        do {
            let session = AVAudioSession.sharedInstance()
            // .playAndRecord with default mode routes to the earpiece (not the speaker)
            try session.setCategory(.playAndRecord, mode: .default, options: [])
            try session.setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.volume = 1.0
            player?.play()
            isPlaying = true
            errorMessage = nil
        } catch {
            errorMessage = "Ear playback error: \(error.localizedDescription)"
        }
    }

    private func stopPlayback() {
        player?.stop()
        player = nil
        isPlaying = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

// MARK: - AVAudioPlayerDelegate

extension ProximityAudioPlayer: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in self.isPlaying = false }
    }
}
