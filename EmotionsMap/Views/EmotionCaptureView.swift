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
    
    private var shellName: String {
        let index = abs(emotionName.hashValue) % 5 + 1
        return "shell_\(index)"
    }

    private var canSave: Bool {
        switch captureMode {
        case .audio: return recorder.savedFileName != nil
        case .text:  return !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case nil:    return false
        }
    }

    var body: some View {
        ZStack {
            // Background
            Color(red: 0.45, green: 0.78, blue: 0.72).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("reflect on your moment")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                    Text("it's you and the shell, remember forever\nwhat are your feelings")
                        .font(.headline.weight(.medium))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Shell & Emotion labels
                        VStack(spacing: 20) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(Color(red: 0.3, green: 0.3, blue: 0.3)) // Dark grey square like in mockup
                                    .frame(width: 200, height: 200)
                                    .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
                                
                                Image(shellName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                            }
                            
                            VStack(alignment: .center, spacing: 4) {
                                Text(emotionName.lowercased())
                                    .font(.title2.weight(.bold))
                                    .foregroundColor(.white)
                                Text(quadrantName.lowercased())
                                    .font(.headline.weight(.medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 40)
                        
                        // Mode Choice or Active Panel
                        if captureMode == nil {
                            modeChoice
                        } else if captureMode == .audio {
                            audioPanel
                        } else {
                            textPanel
                        }
                        
                        // Save Panel
                        if captureMode != nil {
                            VStack(spacing: 12) {
                                Button {
                                    commitAndSave()
                                } label: {
                                    Text("Save")
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(Color(red: 0.45, green: 0.78, blue: 0.72))
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.white)
                                .disabled(!canSave)

                                Button("Change method") {
                                    if recorder.isRecording { recorder.stop() }
                                    withAnimation { captureMode = nil }
                                }
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { recorder.requestPermissions() }
        .onDisappear { if recorder.isRecording { recorder.stop() } }
        .onChange(of: router.checkInPage) { _, newPage in
            if newPage != 2 && recorder.isRecording {
                recorder.stop()
            }
        }
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

    // MARK: – Mode choice

    private var modeChoice: some View {
        HStack(spacing: 50) {
            // Record
            Button {
                withAnimation { captureMode = .audio }
                recorder.savedFileName = nil
                recorder.start()
            } label: {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.35, green: 0.68, blue: 0.62))
                            .frame(width: 90, height: 90)
                        Image(systemName: "play.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.9)) // blue icon
                    }
                    Text("record\nby voice")
                        .font(.headline.weight(.medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
            }
            .buttonStyle(.plain)

            // Write
            Button {
                withAnimation { captureMode = .text }
            } label: {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.35, green: 0.68, blue: 0.62))
                            .frame(width: 90, height: 90)
                        Image(systemName: "pencil")
                            .font(.system(size: 30))
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.9)) // blue icon
                    }
                    Text("start\nwriting")
                        .font(.headline.weight(.medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
            }
            .buttonStyle(.plain)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.96)))
        .padding(.top, 20)
    }

    // MARK: – Audio panel

    private var audioPanel: some View {
        VStack(spacing: 20) {

            // Status
            Text(recorder.isRecording
                 ? "Recording — \(recorder.formattedDuration)"
                 : recorder.savedFileName != nil ? "Recording saved ✓" : "Tap the mic to start")
                .font(.headline.weight(.semibold))
                .foregroundStyle(recorder.isRecording ? .red : .white)

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
                              ? Color.red.opacity(0.15)
                              : Color.white.opacity(0.2))
                        .frame(width: 100, height: 100)

                    if recorder.isRecording {
                        Circle()
                            .stroke(Color.red.opacity(0.5), lineWidth: 2)
                            .frame(width: 100, height: 100)
                            .scaleEffect(1.18)
                            .animation(
                                .easeInOut(duration: 0.9).repeatForever(autoreverses: true),
                                value: recorder.isRecording
                            )
                    }

                    Image(systemName: recorder.isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(recorder.isRecording ? .red : .white)
                }
            }
            .buttonStyle(.plain)

            // Saved row
            if let _ = recorder.savedFileName {
                HStack(spacing: 10) {
                    Image(systemName: "waveform")
                        .foregroundStyle(.white)
                    Text("Voice memo — \(recorder.formattedDuration)")
                        .foregroundColor(.white)
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
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal, 24)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            if let err = recorder.errorMessage {
                Text(err).font(.caption).foregroundStyle(.red)
            }
        }
        .padding(.top, 20)
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    // MARK: – Text panel

    private var textPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("What's on your mind?")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)

            TextEditor(text: $noteText)
                .frame(minHeight: 180)
                .padding(12)
                .background(Color.white.opacity(0.9))
                .cornerRadius(16)
                .padding(.horizontal, 24)
                .scrollContentBackground(.hidden)
        }
        .padding(.top, 20)
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
        
        router.isCheckInPresented = false
        router.shouldResetHomeFlow = true
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
