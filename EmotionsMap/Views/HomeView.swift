//
//  HomeView.swift
//  EmotionsMap
//
//  Created by Riccardo on 2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var flow = HomeFlowState()
    @EnvironmentObject private var router: AppRouter
    
    // Track whether the crab is open or closed
    @State private var isCrabOpen = false
    
    var body: some View {
        ZStack {
            // Background Image
            Image(isCrabOpen ? "hermit_crab_open" : "hermit_crab_closed")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onTapGesture {
                    if !isCrabOpen {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isCrabOpen = true
                            flow.wakeUp()
                        }
                    }
                }
            
            // Instruction prompt if sleeping
            if flow.step == .sleeping && !isCrabOpen {
                VStack {
                    Spacer()
                    Text("Tap the shell to wake up the hermit crab")
                        .font(.headline)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.bottom, 60)
                }
            }
            
            // Interaction UI after crab is open
            if flow.step != .sleeping && isCrabOpen {
                VStack {
                    Spacer()
                    VStack(spacing: 18) {
                        Text(flow.message)
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .foregroundStyle(.primary)

                        buttons
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .padding()
                    .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarHidden(true)
        // Reset flow to sleeping when returning home via router.popToRoot()
        .onChange(of: router.shouldResetHomeFlow) { _, triggered in
            if triggered {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isCrabOpen = false
                    flow.step = .sleeping
                }
                router.shouldResetHomeFlow = false
            }
        }
    }
    
    @ViewBuilder
    private var buttons: some View {
        switch flow.step {

        case .askFeeling:
            VStack(spacing: 12) {
                Button("I'd like to share") {
                    router.startCheckIn()
                }
                .buttonStyle(.borderedProminent)

                Button("Not right now") {
                    flow.chooseNotNow()
                }
                .buttonStyle(.bordered)
            }

        case .askReflect:
            VStack(spacing: 12) {
                Button("Yes, show me") {
                    router.openArchive()
                }
                .buttonStyle(.borderedProminent)

                Button("No, I'd rather share something new") {
                    router.startCheckIn()
                }
                .buttonStyle(.bordered)
            }

        default:
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(AppRouter())
    }
}
