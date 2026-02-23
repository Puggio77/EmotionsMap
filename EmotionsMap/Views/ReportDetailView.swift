//
//  ReportDetailView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI

struct ReportDetailView: View {
    let report: MoodReport
    @StateObject private var player = VoicePlayer()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // ── Emotion header ───────────────────────────────────
                VStack(alignment: .leading, spacing: 6) {
                    Text(report.moodLabel)
                        .font(.title2.weight(.semibold))

                    if let specific = report.specificEmotion {
                        Text(specific)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    Text(report.createdAt.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                // ── Voice memo ───────────────────────────────────────
                if let audioFileName = report.audioFileName {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Voice memo", systemImage: "waveform")
                            .font(.headline)

                        Button {
                            player.toggle(fileName: audioFileName)
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.accentColor.opacity(0.12))
                                        .frame(width: 52, height: 52)
                                    Image(systemName: player.isPlaying ? "stop.fill" : "play.fill")
                                        .font(.system(size: 22))
                                        .foregroundStyle(Color.accentColor)
                                }
                                Text(player.isPlaying ? "Playing…" : "Tap to listen")
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)

                        if let err = player.errorMessage {
                            Text(err)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }

                // ── Written note ─────────────────────────────────────
                if !report.triggerText.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Written note", systemImage: "pencil")
                            .font(.headline)

                        if report.isTriggerHidden {
                            Text("•••••••• (hidden)")
                                .foregroundStyle(.secondary)
                        } else {
                            Text(report.triggerText)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }

                // ── Spectrum coords ──────────────────────────────────
                VStack(alignment: .leading, spacing: 6) {
                    Label("Spectrum position", systemImage: "scope")
                        .font(.headline)
                    Text(String(format: "x: %.2f   y: %.2f", report.x, report.y))
                        .font(.body.monospaced())
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: – Preview

#Preview {
    NavigationStack {
        ReportDetailView(
            report: MoodReport(
                x: 0.7,
                y: 0.3,
                moodLabel: "Calm / Relaxed",
                specificEmotion: "Peaceful",
                triggerText: "A walk in the park",
                isTriggerHidden: false,
                audioFileName: nil
            )
        )
    }
}
