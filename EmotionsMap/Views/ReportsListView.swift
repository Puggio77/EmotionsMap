//
//  ReportsListView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI

struct ReportsListView: View {
    @EnvironmentObject private var store: ReportStore

    var body: some View {
        List {
            if store.reports.isEmpty {
                Text("No report saved.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(store.reports) { report in
                    NavigationLink {
                        ReportDetailView(report: report)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(report.moodLabel)
                                .font(.headline)

                            Text(report.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: store.delete)
            }
        }
        .navigationTitle("Report")
        .toolbar {
            EditButton()
        }
    }
}

#Preview {
    ReportsListView()
}
