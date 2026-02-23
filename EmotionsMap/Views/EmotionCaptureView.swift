//
//  EmotionCaptureView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 23/02/26.
//

import SwiftUI
import AVFoundation

// MARK: - Capture mode

private enum CaptureMode {
    case audio, text
}

// MARK: - View

struct EmotionCaptureView: View {

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: ReportStore

    @StateObject private var recorder = VoiceRecorder()

    @State private var captureMode: CaptureMode? = nil
    @State private var noteText: String = ""

    // Derived from router.vm (set by EmotionDetailView)
    private var emotionName: String  { router.vm.specificEmotion ?? router.vm.moodLabel }
    private var quadrantName: String { router.vm.moodLabel }

    private var canSave: Bool {
        switch captureMode {
        case .audio: return recorder.savedFileName != nil
        case .text:  return !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case nil:    return false
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {

                // ── Emotion hero ─────────────────────────────────────
                emotionHero

                // ── Mode choice or active panel ──────────────────────
                if captureMode == nil {
                    modeChoice
                } else if captureMode == .audio {
                    audioPanel
                } else {
                    textPanel
                }

                // ── Save ─────────────────────────────────────────────
                if captureMode != nil {
                    VStack(spacing: 12) {

                        Button {
                            commitAndSave()
                        } label: {
                            Text("Save & see archive")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!canSave)

                        Button("Change method") {
                            if recorder.isRecording { recorder.stop() }
                            withAnimation { captureMode = nil }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.vertical, 24)
        }
        .navigationTitle("Capture")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { recorder.requestPermissions() }
        .onDisappear { if recorder.isRecording { recorder.stop() } }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: captureMode)
        .alert("Microphone Access Required",
               isPresented: $recorder.permissionDenied) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please allow microphone access in Settings to record audio.")
        }
    }

    // MARK: – Emotion hero

    private var emotionHero: some View {
        VStack(spacing: 12) {
            Text(emotionName)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)

            Text(quadrantName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(.thinMaterial)
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }

    // MARK: – Mode choice

    private var modeChoice: some View {
        VStack(spacing: 16) {
            Text("How would you like to capture this feeling?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            HStack(spacing: 14) {
                // Record
                Button {
                    withAnimation { captureMode = .audio }
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 36))
                        Text("Record\nvoice")
                            .font(.subheadline.weight(.semibold))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                .buttonStyle(.plain)

                // Write
                Button {
                    withAnimation { captureMode = .text }
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: "pencil.line")
                            .font(.system(size: 36))
                        Text("Write it\ndown")
                            .font(.subheadline.weight(.semibold))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.96)))
    }

    // MARK: – Audio panel

    private var audioPanel: some View {
        VStack(spacing: 20) {

            // Status
            Text(recorder.isRecording
                 ? "Recording — \(recorder.formattedDuration)"
                 : recorder.savedFileName != nil ? "Recording saved ✓" : "Tap to start")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(recorder.isRecording ? .red : .secondary)

            // Mic button
            Button {
                if recorder.isRecording {
                    recorder.stop()
                } else {
                    recorder.savedFileName = nil
                    recorder.start()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(recorder.isRecording
                              ? Color.red.opacity(0.12)
                              : Color.accentColor.opacity(0.10))
                        .frame(width: 96, height: 96)

                    if recorder.isRecording {
                        Circle()
                            .stroke(Color.red.opacity(0.25), lineWidth: 2)
                            .frame(width: 96, height: 96)
                            .scaleEffect(1.18)
                            .animation(
                                .easeInOut(duration: 0.9).repeatForever(autoreverses: true),
                                value: recorder.isRecording
                            )
                    }

                    Image(systemName: recorder.isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 38))
                        .foregroundStyle(recorder.isRecording ? .red : Color.accentColor)
                }
            }
            .buttonStyle(.plain)

            // Saved row
            if let _ = recorder.savedFileName {
                HStack(spacing: 10) {
                    Image(systemName: "waveform")
                        .foregroundStyle(Color.accentColor)
                    Text("Voice memo — \(recorder.formattedDuration)")
                    Spacer()
                    Button {
                        recorder.savedFileName = nil
                        recorder.elapsedSeconds = 0
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            if let err = recorder.errorMessage {
                Text(err).font(.caption).foregroundStyle(.red)
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    // MARK: – Text panel

    private var textPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("What's on your mind?")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal)

            TextEditor(text: $noteText)
                .frame(minHeight: 160)
                .padding(12)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal)
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    // MARK: – Save

    private func commitAndSave() {
        if recorder.isRecording { recorder.stop() }

        switch captureMode {
        case .audio:
            router.vm.audioFileName = recorder.savedFileName
            router.vm.triggerText   = ""
        case .text:
            router.vm.triggerText   = noteText
            router.vm.audioFileName = nil
        case nil:
            break
        }

        let report = router.vm.buildReport()
        store.add(report)
        router.path.append(AppRoute.archive)
    }
}

// MARK: – Preview

#Preview {
    NavigationStack {
        EmotionCaptureView()
            .environmentObject({
                let r = AppRouter()
                r.vm.specificEmotion = "Peaceful"
                r.vm.x = 0.7; r.vm.y = 0.3
                return r
            }())
            .environmentObject(ReportStore())
    }
}
