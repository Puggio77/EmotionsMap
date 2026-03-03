//
//  VoicePlayer.swift
//  EmotionsMap
//

import Foundation
import AVFoundation
import Combine

// MARK: - Speaker playback

@MainActor
final class VoicePlayer: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var errorMessage: String? = nil

    private var player: AVAudioPlayer?

    func toggle(fileName: String) {
        if isPlaying {
            player?.stop()
            isPlaying = false
        } else {
            play(fileName: fileName)
        }
    }

    private func play(fileName: String) {
        let url = VoiceRecorder.documentsURL(for: fileName)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            isPlaying = true

            let duration = player?.duration ?? 0
            Task {
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                self.isPlaying = false
            }
        } catch {
            errorMessage = "Could not play audio: \(error.localizedDescription)"
        }
    }
}
