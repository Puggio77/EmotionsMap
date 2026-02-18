//
//  ReportStore.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ReportStore: ObservableObject {
    @Published private(set) var reports: [MoodReport] = []

    private let fileName = "mood_reports.json"

    init() {
        load()
    }

    func add(_ report: MoodReport) {
        reports.insert(report, at: 0)
        save()
    }

    func delete(at offsets: IndexSet) {
        reports.remove(atOffsets: offsets)
        save()
    }

    func load() {
        do {
            let url = try fileURL()
            guard FileManager.default.fileExists(atPath: url.path) else {
                reports = []
                return
            }
            let data = try Data(contentsOf: url)
            reports = try JSONDecoder().decode([MoodReport].self, from: data)
        } catch {
            // fallback safe
            reports = []
            print("Load error:", error)
        }
    }

    private func save() {
        do {
            let url = try fileURL()
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(reports)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Save error:", error)
        }
    }

    private func fileURL() throws -> URL {
        let dir = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        return dir.appendingPathComponent(fileName)
    }
}
