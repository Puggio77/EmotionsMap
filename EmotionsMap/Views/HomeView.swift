//
//  HomeView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Button {
                vm.wakeUp()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(vm.isAwake ? Color.blue : Color.clear)
                        .frame(width: 220, height: 220)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(.secondary.opacity(0.4), lineWidth: 1)
                        )

                    Text("Avatar")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(vm.isAwake ? .white : .primary)
                }

            }
            .buttonStyle(.plain)

            Text(vm.greeting)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack(spacing: 12) {
                NavigationLink {
                    EmotionSpectrumView()
                } label: {
                    Text("Answer")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!vm.isAwake)

                NavigationLink {
                    ReportsListView()
                } label: {
                    Text("Report")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Home")
    }
}

#Preview {
    HomeView()
}
