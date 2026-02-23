//
//  IMImmersiveHomeView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 20/02/26.
//

import SwiftUI
import Combine

struct IMImmersiveHomeView: View {

    @StateObject private var flow = IMFlowState()
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {

            if #available(iOS 17.0, *) {
                IMImmersiveIslandCrabView {
                    if flow.step == IMFlowState.Step.sleeping {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            flow.wakeUp()
                        }
                    }
                }
            } else {
                Color.black.ignoresSafeArea()
            }

            if flow.step != IMFlowState.Step.sleeping {
                VStack {
                    Spacer()
                    VStack(spacing: 18) {
                        Text(flow.message)
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .foregroundStyle(.white)

                        buttons
                    }
                    .padding()
                    .background(.black.opacity(0.65))
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .padding()
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarHidden(true)
        // Reset flow to sleeping when returning home via router.popToRoot()
        .onChange(of: router.shouldResetHomeFlow) { _, triggered in
            if triggered {
                withAnimation(.easeInOut(duration: 0.25)) {
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
        IMImmersiveHomeView()
            .environmentObject(ReportStore())
            .environmentObject(AppRouter())
    }
}
