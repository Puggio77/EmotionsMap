//
//  TriggerView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI

struct TriggerView: View {
    @EnvironmentObject private var store: ReportStore
    @ObservedObject var vm: CheckInViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var goToReports = false

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Recorded emotion:")
                    .font(.subheadline.weight(.semibold))
                Text(vm.moodLabel)
                    .font(.title3.weight(.semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Trigger (what caused it?)", text: $vm.triggerText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)

            Spacer()

            Button {
                let report = vm.buildReport()
                store.add(report)
                goToReports = true
            } label: {
                Text("Save report")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!vm.canSave)

            NavigationLink("", isActive: $goToReports) {
                ReportsListView()
            }
            .hidden()
        }
        .padding()
        .navigationTitle("Trigger")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack {
        TriggerView(vm: CheckInViewModel())
            .environmentObject(ReportStore())
    }
}
