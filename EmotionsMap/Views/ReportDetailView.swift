//
//  ReportDetailView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI

struct ReportDetailView: View {
    let report: MoodReport

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(report.moodLabel)
                    .font(.title2.weight(.semibold))

                Text(report.createdAt.formatted(date: .long, time: .shortened))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 8) {
                Text("Spectrum (x,y)")
                    .font(.headline)
                Text(String(format: "x: %.2f   y: %.2f", report.x, report.y))
                    .font(.body.monospaced())
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 8) {
                Text("Trigger")
                    .font(.headline)

                if report.isTriggerHidden {
                    Text("•••••••• (hidden)")
                        .foregroundStyle(.secondary)
                } else {
                    Text(report.triggerText.isEmpty ? "—" : report.triggerText)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .padding()
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ReportDetailView(
        report: MoodReport(
            x: 0.7,
            y: 0.3,
            moodLabel: "Sereno / Rilassato",
            triggerText: "Una passeggiata",
            isTriggerHidden: false
        )
    )
}

