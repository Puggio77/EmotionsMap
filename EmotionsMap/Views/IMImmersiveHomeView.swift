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

            NavigationLink(
                destination: IMEmotionEntryView(),
                isActive: Binding(
                    get: { flow.step == IMFlowState.Step.goToRecord },
                    set: { _ in }
                )
            ) { EmptyView() }

            NavigationLink(
                destination: IMPastReflectionsView(),
                isActive: Binding(
                    get: { flow.step == IMFlowState.Step.goToHistory },
                    set: { _ in }
                )
            ) { EmptyView() }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var buttons: some View {
        switch flow.step {

        case .askFeeling:
            VStack(spacing: 12) {
                Button("I’d like to share") {
                    flow.chooseRecord()
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
                    flow.chooseHistory()
                }
                .buttonStyle(.borderedProminent)

                Button("No, I’d rather share something new") {
                    flow.chooseRecord()
                }
                .buttonStyle(.bordered)
            }

        default:
            EmptyView()
        }
    }
}
