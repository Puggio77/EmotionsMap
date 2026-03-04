//
//  PastReflectionsView.swift
//  EmotionsMap
//
//  Created by Riccardo on 2026.
//

import SwiftUI

struct PastReflectionsView: View {
    @EnvironmentObject private var store: ReportStore


    private var sortedReports: [MoodReport] {
        store.reports.sorted { $0.createdAt > $1.createdAt }
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

=======
    @EnvironmentObject private var router: AppRouter
    @State private var showHelpLines = false
    

    var body: some View {
        ZStack {
            Color(red: 129/255, green: 205/255, blue: 192/255).ignoresSafeArea()

            if sortedReports.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.8))
                    Text("you have not collected any shells yet")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
            } else {
                ScrollView {
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

                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(sortedReports) { report in
                                NavigationLink {
                                    ReportDetailView(report: report)
                                } label: {
                                    ShellGridCell(report: report)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showHelpLines = true
                } label: {
                    Image(systemName: "sos.circle.fill")
                        .foregroundStyle(.red)
                }
            }
        }
        .sheet(isPresented: $showHelpLines) {
            HelpLinesView()
        }
    }
}

// MARK: - Grid Cell

private struct ShellGridCell: View {
    let report: MoodReport

    private var shellName: String {
        let name = report.specificEmotion ?? report.moodLabel
        let index = abs(name.hashValue) % 5 + 1
        return "shell_\(index)"
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()

    var body: some View {
        VStack(spacing: 6) {
            ColoredShell(
                shellName: shellName,
                color: Color(report.basicEmotion.hexColor)
            )
            .scaledToFit()
            .aspectRatio(1, contentMode: .fit)

            Text((report.specificEmotion ?? report.moodLabel).lowercased())
                .font(.caption.weight(.semibold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(Self.dateFormatter.string(from: report.createdAt))
                .font(.caption2)
                .foregroundColor(.white.opacity(0.75))
        }
        .padding(8)
        .background(Color.white.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        PastReflectionsView()
            .environmentObject(ReportStore())
            .environmentObject(AppRouter())
    }
}
