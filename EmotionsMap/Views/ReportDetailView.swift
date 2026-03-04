//
//  ReportDetailView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI
import SwiftData

struct ReportDetailView: View {
    let report: MoodReport
    @StateObject private var player = VoicePlayer()
    @StateObject private var proximityPlayer = ProximityAudioPlayer()
    
    private var shellName: String {
        let emotionName = report.specificEmotion ?? report.moodLabel
        let index = abs(emotionName.hashValue) % 5 + 1
        return "shell_\(index)"
    }
    
    private var emotionColor: Color {
        let rawAttrs = EmotionsData.all
        for attr in rawAttrs {
            // Check specific emotion matches
            if attr.specificEmotions.contains(where: { $0.name == report.specificEmotion }) {
                return Color(attr.basicEmotion.hexColor)
            } 
            // Check sub emotion (mood label) matches
            else if attr.subEmotion == report.moodLabel {
                return Color(attr.basicEmotion.hexColor)
            }
        }
        // Fallback to a default color (e.g., light blue for sea vibe)
        return Color(red: 0.2, green: 0.6, blue: 0.8)
    }
    
    var body: some View {
        ZStack {
            // Sea background color matching the app
            Color(red: 129/255, green: 205/255, blue: 192/255)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // ── Emotion header with Shell ─────────────────────────
                    VStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
                                .frame(width: 160, height: 160)
                                .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
                            
                            ColoredShell(
                                shellName: shellName,
                                color: emotionColor
                            )
                            .scaledToFit()
                            .frame(width: 115, height: 115)
                        }
                        
                        VStack(spacing: 4) {
                            Text((report.specificEmotion ?? report.moodLabel).lowercased())
                                .font(.title2.weight(.bold))
                                .foregroundColor(.white)
                            
                            if report.specificEmotion != nil {
                                Text(report.moodLabel.lowercased())
                                    .font(.headline.weight(.medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            
                            Text(report.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.75))
                                .padding(.top, 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    
                    // ── Voice memo ───────────────────────────────────────
                    if let audioFileName = report.audioFileName {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Voice memo", systemImage: "waveform")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            // Manual speaker playback
                            Button {
                                player.toggle(fileName: audioFileName)
                            } label: {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.2))
                                            .frame(width: 52, height: 52)
                                        Image(systemName: player.isPlaying ? "stop.fill" : "play.fill")
                                            .font(.system(size: 22))
                                            .foregroundColor(.white)
                                    }
                                    Text(player.isPlaying ? "Playing…" : "Tap to listen")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
                            
                            // Ear-playback hint
                            Label(
                                proximityPlayer.isPlaying ? "Playing through earpiece…" : "Bring phone to ear to listen",
                                systemImage: proximityPlayer.isPlaying ? "ear.fill" : "ear"
                            )
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .animation(.easeInOut(duration: 0.25), value: proximityPlayer.isPlaying)
                            
                            if let err = player.errorMessage {
                                Text(err)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.black.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .onAppear  { proximityPlayer.activate(fileName: audioFileName) }
                        .onDisappear { proximityPlayer.deactivate() }
                    }
                    
                    // ── Written note ─────────────────────────────────────
                    if !report.triggerText.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Written note", systemImage: "pencil")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if report.isTriggerHidden {
                                Text("•••••••• (hidden)")
                                    .foregroundColor(.white.opacity(0.6))
                            } else {
                                Text(report.triggerText)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.black.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .background(Color(red: 129/255, green: 205/255, blue: 192/255).ignoresSafeArea())
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
            // Ensure standard back button and title color works with the teal background
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(red: 129/255, green: 205/255, blue: 192/255), for: .navigationBar)
        }
    }
}
    // MARK: – Preview
    
    #Preview("ReportDetailView") {
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
