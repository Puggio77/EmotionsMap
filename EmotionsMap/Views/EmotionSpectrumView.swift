//
//  EmotionSpectrumView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI

struct EmotionSpectrumView: View {
    @StateObject private var vm = CheckInViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("Place a point on the spectrum")
                .font(.headline)

            SpectrumPicker(x: $vm.x, y: $vm.y)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("How I interpret it:")
                    .font(.subheadline.weight(.semibold))
                Text(vm.moodLabel)
                    .font(.title3.weight(.semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            Spacer()

            NavigationLink {
                TriggerView(vm: vm)
            } label: {
                Text("Next")
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
    EmotionSpectrumView()
}
