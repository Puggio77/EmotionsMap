//
//  ReportStore.swift
//  EmotionsMap
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@MainActor
final class ReportStore: ObservableObject {
    @Published private(set) var reports: [MoodReport] = []
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchReports()
    }

    func refresh() {
        fetchReports()
    }

    private func fetchReports() {
        let descriptor = FetchDescriptor<MoodReport>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        reports = (try? modelContext.fetch(descriptor)) ?? []
    }
}
