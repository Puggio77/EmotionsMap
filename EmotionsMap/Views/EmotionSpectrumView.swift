//
//  EmotionSpectrumView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI

struct EmotionSpectrumView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        VStack(spacing: 16) {
            Text("Place a point on the spectrum")
                .font(.headline)

            SpectrumPicker(
                x: Binding(get: { router.vm.x }, set: { router.vm.x = $0 }),
                y: Binding(get: { router.vm.y }, set: { router.vm.y = $0 })
            )
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("How I interpret it:")
                    .font(.subheadline.weight(.semibold))
                Text(router.vm.moodLabel)
                    .font(.title3.weight(.semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            Spacer()

            Button {
                router.path.append(AppRoute.emotionDetail)
            } label: {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .padding(.top, 12)
        .navigationTitle("Emotions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EmotionSpectrumView()
            .environmentObject(AppRouter())
    }
}
