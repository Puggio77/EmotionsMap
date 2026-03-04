//
//  OnboardingView.swift
//  EmotionsMap
//
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    // Using existing assets for the onboarding pages
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to EmotionsMap",
            description: "A safe space to understand and track how you feel every day.",
            imageName: "hermit_crab_closed"
        ),
        OnboardingPage(
            title: "Explore the Island",
            description: "Navigate through your emotional landscape and discover the depth of your feelings.",
            imageName: "island map"
        ),
        OnboardingPage(
            title: "Reflect and Save",
            description: "Capture your deepest thoughts in a shell and build your personal emotional archive.",
            imageName: "shell_1" // Since we use coloured shells dynamically elsewhere, we'll just try to use one if available in assets, or Hermie open
        )
    ]
    
    var body: some View {
        ZStack {
            // Background matching the app's soothing theme
            Color(red: 129/255, green: 205/255, blue: 192/255)
                .ignoresSafeArea()
            
            VStack {
                // Skip Button
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding()
                    } else {
                        // Empty spacer to keep layout balanced
                        Text("Skip")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.clear)
                            .padding()
                    }
                }
                
                // Paged Content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Indicators and Actions
                VStack(spacing: 24) {
                    // Custom Paging Dots
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.white : Color.white.opacity(0.35))
                                .frame(width: index == currentPage ? 10 : 7,
                                       height: index == currentPage ? 10 : 7)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    // Main Action Button
                    Button {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            completeOnboarding()
                        }
                    } label: {
                        Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    // .tint(.white) -> to avoid white text on white button, custom styling:
                    .tint(.white)
                    .foregroundStyle(Color(red: 129/255, green: 205/255, blue: 192/255))
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            // Preload haptics
            let gen = UIImpactFeedbackGenerator(style: .light)
            gen.prepare()
        }
        .onChange(of: currentPage) { _, _ in
            let gen = UIImpactFeedbackGenerator(style: .light)
            gen.impactOccurred()
        }
    }
    
    private func completeOnboarding() {
        let gen = UIImpactFeedbackGenerator(style: .medium)
        gen.impactOccurred()
        withAnimation(.easeInOut) {
            hasSeenOnboarding = true
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Reusing existing image names.
            // fallback generic styling if image isn't found exactly
            Image(page.imageName.isEmpty ? "hermit_crab_open" : page.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 250)
                .padding()
            
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
