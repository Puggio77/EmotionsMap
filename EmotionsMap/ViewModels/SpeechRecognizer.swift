//
//  VoiceRecorder.swift
//  EmotionsMap
//
//  Note: VoicePlayer → VoicePlayer.swift
//        ProximityAudioPlayer → ProximityAudioPlayer.swift
//

import Foundation
import Combine
import AVFoundation
import UIKit

// MARK: - Voice Recorder

@MainActor
final class VoiceRecorder: NSObject, ObservableObject {

    // MARK: - Published state

    @Published var isRecording: Bool = false
    @Published var elapsedSeconds: Int = 0
    @Published var savedFileName: String? = nil
    @Published var permissionDenied: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Private

    private var recorder: AVAudioRecorder?
    private var timer: AnyCancellable?
    private var currentFileName: String = ""

    // MARK: - Permissions

    func requestPermissions() {
        AVAudioApplication.requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                if !granted { self?.permissionDenied = true }
            }
        }
    }

    // MARK: - Recording

    func start() {
        guard !isRecording else { return }
        let fileName = "\(UUID().uuidString).m4a"
        currentFileName = fileName

        let url = documentsURL(for: fileName)
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.record, mode: .default)
            try session.setActive(true)

            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.delegate = self
            recorder?.record()

            isRecording = true
            savedFileName = nil
            elapsedSeconds = 0
            errorMessage = nil

            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in self?.elapsedSeconds += 1 }
        } catch {
            errorMessage = "Could not start recording: \(error.localizedDescription)"
        }
    }

    func stop() {
        recorder?.stop()
        timer?.cancel()
        timer = nil
        isRecording = false
        savedFileName = currentFileName
        try? AVAudioSession.sharedInstance().setActive(false)
    }

    // MARK: - Helpers

    func deleteFile(_ fileName: String) {
        let url = documentsURL(for: fileName)
        try? FileManager.default.removeItem(at: url)
    }

    static func documentsURL(for fileName: String) -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent(fileName)
    }

    private func documentsURL(for fileName: String) -> URL {
        VoiceRecorder.documentsURL(for: fileName)
    }

    var formattedDuration: String {
        let m = elapsedSeconds / 60
        let s = elapsedSeconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

// MARK: - AVAudioRecorderDelegate

extension VoiceRecorder: AVAudioRecorderDelegate {
    nonisolated func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            Task { @MainActor in
                self.errorMessage = "Recording failed."
                self.savedFileName = nil
            }
        }
    }
}
