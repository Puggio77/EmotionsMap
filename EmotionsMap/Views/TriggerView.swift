//
//  TriggerView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI
import AVFoundation

struct TriggerView: View {
    @EnvironmentObject private var store: ReportStore
    @ObservedObject var vm: CheckInViewModel
    @Environment(\.dismiss) private var dismiss

    @StateObject private var recorder = VoiceRecorder()
    @State private var inputMode: InputMode = .text
    @State private var goToArchive = false

    enum InputMode { case text, voice }

    // A report can be saved if the user either wrote something OR recorded audio
    private var canSave: Bool {
        inputMode == .text ? true : (recorder.savedFileName != nil || vm.audioFileName != nil)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // ── Emotion recap ────────────────────────────────────
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Recorded emotion")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(vm.moodLabel)
                            .font(.title3.weight(.bold))
                        if let specific = vm.specificEmotion {
                            Text(specific)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                // ── Mode picker ──────────────────────────────────────
                Picker("Input mode", selection: $inputMode) {
                    Label("Write", systemImage: "pencil").tag(InputMode.text)
                    Label("Record voice", systemImage: "mic.fill").tag(InputMode.voice)
                }
                .pickerStyle(.segmented)
                .onChange(of: inputMode) { _, _ in
                    if recorder.isRecording { recorder.stop() }
                }

                // ── Input area ───────────────────────────────────────
                switch inputMode {
                case .text:
                    textPanel
                case .voice:
                    voicePanel
                }

                Spacer(minLength: 8)

                // ── Save ─────────────────────────────────────────────
                Button {
                    if recorder.isRecording { recorder.stop() }
                    // Commit voice recording filename to the VM
                    if inputMode == .voice {
                        vm.audioFileName = recorder.savedFileName
                        vm.triggerText = ""
                    }
                    let report = vm.buildReport()
                    store.add(report)
                    goToArchive = true
                } label: {
                    Text("Save & see archive")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canSave)

                NavigationLink("", isActive: $goToArchive) {
                    IMPastReflectionsView()
                }
                .hidden()
            }
            .padding()
        }
        .navigationTitle("Describe it")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { recorder.requestPermissions() }
        .onDisappear { if recorder.isRecording { recorder.stop() } }
        .alert("Microphone Access Required",
               isPresented: $recorder.permissionDenied) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { inputMode = .text }
        } message: {
            Text("Please allow microphone access in Settings.")
        }
    }

    // MARK: – Text panel

    private var textPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What caused this feeling?")
                .font(.subheadline.weight(.semibold))
            TextField("Write your thoughts here…", text: $vm.triggerText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(4...8)
        }
    }

    // MARK: – Voice panel

    private var voicePanel: some View {
        VStack(spacing: 20) {

            // Status label
            Text(recorder.isRecording
                 ? "Recording… \(recorder.formattedDuration)"
                 : recorder.savedFileName != nil ? "Recording saved ✓" : "Tap to start recording")
                .font(.subheadline)
                .foregroundStyle(recorder.isRecording ? .red : .secondary)
                .animation(.default, value: recorder.isRecording)

            // Record / stop button
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
                              : Color.accentColor.opacity(0.12))
                        .frame(width: 88, height: 88)

                    if recorder.isRecording {
                        // Pulsing ring
                        Circle()
                            .stroke(Color.red.opacity(0.3), lineWidth: 3)
                            .frame(width: 88, height: 88)
                            .scaleEffect(1.15)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                                       value: recorder.isRecording)
                    }

                    Image(systemName: recorder.isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(recorder.isRecording ? .red : .accentColor)
                }
            }
            .buttonStyle(.plain)

            // Saved recording info
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
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            if let err = recorder.errorMessage {
                Text(err)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .animation(.spring(response: 0.35), value: recorder.savedFileName)
    }
}

// MARK: – Preview

#Preview {
    NavigationStack {
        TriggerView(vm: CheckInViewModel())
            .environmentObject(ReportStore())
    }
}
