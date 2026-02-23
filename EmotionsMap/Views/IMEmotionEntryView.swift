//
//  IMEmotionEntryView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 20/02/26.
//


import SwiftUI

struct IMEmotionEntryView: View {

    @State private var text: String = ""

    var body: some View {
        VStack(spacing: 24) {

            Text("Express your emotions")
                .font(.title2)

            TextEditor(text: $text)
                .frame(height: 220)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Button("Save") {
                // TODO: salva nel ReportStore
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("New Entry")
    }
}

#Preview {
    NavigationStack {
        IMEmotionEntryView()
    }
}