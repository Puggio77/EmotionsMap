//
//  IMPastReflectionsView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 20/02/26.
//

import SwiftUI

// MARK: - Helpers

private extension MoodReport {
    /// SF Symbol icon for the broad quadrant
    var quadrantIcon: String {
        switch moodLabel {
        case "Anxious / Tense":           return "cloud.drizzle.fill"
        case "Energetic / Enthusiastic":  return "sun.max.fill"
        case "Sad / Low":                 return "cloud.rain.fill"
        case "Calm / Relaxed":            return "leaf.fill"
        default:                          return "circle.fill"
        }
    }

    /// Colour tint for the icon
    var quadrantColor: Color {
        switch moodLabel {
        case "Anxious / Tense":           return .orange
        case "Energetic / Enthusiastic":  return .yellow
        case "Sad / Low":                 return .indigo
        case "Calm / Relaxed":            return .green
        default:                          return .secondary
        }
    }

    /// Section bucket
    var bucket: String {
        if Calendar.current.isDateInToday(createdAt) { return "Today" }
        if let days = Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day,
           days < 7 { return "This week" }
        return createdAt.formatted(.dateTime.month(.wide).year())
    }
}

// MARK: - Main view

struct IMPastReflectionsView: View {
    @EnvironmentObject private var store: ReportStore
    @EnvironmentObject private var router: AppRouter

    /// Reports grouped by bucket, order preserved
    private var grouped: [(key: String, reports: [MoodReport])] {
        let buckets = ["Today", "This week"]
        var dict: [String: [MoodReport]] = [:]
        for r in store.reports {
            dict[r.bucket, default: []].append(r)
        }
        // Sort: Today first, then This week, then months newest-first
        let monthKeys = dict.keys
            .filter { !buckets.contains($0) }
            .sorted(by: >)
        let orderedKeys = buckets.filter { dict[$0] != nil } + monthKeys
        return orderedKeys.map { (key: $0, reports: dict[$0]!) }
    }

    var body: some View {
        Group {
            if store.reports.isEmpty {
                emptyState
            } else {
                archiveList
            }
        }
        .navigationTitle("Reflections Archive")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    router.popToRoot()
                } label: {
                    Label("Home", systemImage: "house")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }

    // MARK: – Archive list

    private var archiveList: some View {
        List {
            ForEach(grouped, id: \.key) { section in
                Section(section.key) {
                    ForEach(section.reports) { report in
                        NavigationLink {
                            ReportDetailView(report: report)
                        } label: {
                            reportRow(report)
                        }
                    }
                    .onDelete { offsets in
                        // map local offsets back to store
                        let globalOffsets = offsets.map { section.reports[$0] }
                            .compactMap { r in store.reports.firstIndex(where: { $0.id == r.id }) }
                        store.delete(at: IndexSet(globalOffsets))
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    @ViewBuilder
    private func reportRow(_ report: MoodReport) -> some View {
        HStack(spacing: 14) {
            // Icon badge
            ZStack {
                Circle()
                    .fill(report.quadrantColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: report.quadrantIcon)
                    .font(.system(size: 20))
                    .foregroundStyle(report.quadrantColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(report.moodLabel)
                    .font(.headline)
                if !report.triggerText.isEmpty && !report.isTriggerHidden {
                    Text(report.triggerText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Text(report.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                if report.audioFileName != nil {
                    Label("Voice memo", systemImage: "waveform")
                        .font(.caption)
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: – Empty state

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundStyle(.tertiary)
            Text("No reflections yet")
                .font(.title3.weight(.semibold))
            Text("After you share an emotion, it will appear here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

// MARK: – Preview

#Preview {
    NavigationStack {
        IMPastReflectionsView()
            .environmentObject(ReportStore())
            .environmentObject(AppRouter())
    }
}