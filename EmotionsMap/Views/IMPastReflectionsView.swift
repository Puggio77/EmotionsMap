//
//  IMPastReflectionsView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 20/02/26.
//


import SwiftUI

struct IMPastReflectionsView: View {

    var body: some View {
        VStack(spacing: 24) {
            Text("Your previous reflections")
                .font(.title2)

            Text("No entries yet")
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Reflections")
    }
}