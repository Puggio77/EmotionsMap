//
//  PastReflectionsView.swift
//  EmotionsMap
//
//  Created by Riccardo on 2026.
//

import SwiftUI

struct PastReflectionsView: View {
    @EnvironmentObject private var store: ReportStore
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.45, green: 0.78, blue: 0.72).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("your past feelings")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                    Text("here is a safe space with all the shells\nyou collected")
                        .font(.headline.weight(.medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                if store.reports.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.8))
                        Text("you have not collected any shells yet")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(store.reports) { report in
                                ReflectionRow(report: report)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                     }
                }
                
                // Return Home Button
                Button {
                    router.popToRoot()
                } label: {
                    Text("Return Home")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(red: 0.45, green: 0.78, blue: 0.72))
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(red: 0.45, green: 0.78, blue: 0.72))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reflection Row
private struct ReflectionRow: View {
    let report: MoodReport
    
    // Deterministic random shell based on emotion ID
    private var shellName: String {
        let name = report.specificEmotion ?? report.moodLabel
        let index = abs(name.hashValue) % 5 + 1
        return "shell_\(index)"
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Shell icon with square background
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.1), radius: 5, y: 3)
                
                Image(shellName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            
            // Texts
            VStack(alignment: .leading, spacing: 6) {
                Text(report.moodLabel.lowercased())
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                
                if let specific = report.specificEmotion {
                    Text(specific.lowercased())
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white.opacity(0.95))
                }
                
                Text(report.createdAt.formatted(date: .abbreviated, time: .shortened).lowercased())
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.75))
            }
            
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    NavigationStack {
        PastReflectionsView()
            .environmentObject(ReportStore())
            .environmentObject(AppRouter())
    }
}
