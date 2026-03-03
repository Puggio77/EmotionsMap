//
//  EmotionMapIslandView.swift
//  EmotionsMap
//
//  Created by Riccardo on 2026.
//

import SwiftUI

struct EmotionMapIslandView: View {
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        ZStack {
            // Background representing the ocean
            Color(red: 129/255, green: 205/255, blue: 192/255).ignoresSafeArea()
            
            VStack {
                Text("Where are you on the island?")
                    .font(.title2.bold())
                    .padding(.top)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                Spacer()
                
                // Map layout area
                ZStack {
                    // Base Island Shape
                    Image("island map")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 380, height: 380)
                    
                    // The Volcano of anger
                    IslandLocationButton(
                        name: "The Volcano of anger",
                        color: .red
                    ) {
                        router.vm.manualMoodLabel = "Anxious / Tense"
                        withAnimation { router.checkInPage = 1 }
                    }
                    .offset(x: 70, y: -140)
                    
                    // The cave of disgust
                    IslandLocationButton(
                        name: "The cave of disgust",
                        color: .purple
                    ) {
                        router.vm.manualMoodLabel = "Neutral" // Or map to a new category if needed
                        withAnimation { router.checkInPage = 1 }
                    }
                    .offset(x: -80, y: -110)
                    
                    // The forest of fear
                    IslandLocationButton(
                        name: "The forest of fear",
                        color: Color(red: 0.1, green: 0.3, blue: 0.1)
                    ) {
                        router.vm.manualMoodLabel = "Anxious / Tense"
                        withAnimation { router.checkInPage = 1 }
                    }
                    .offset(x: -70, y: 0)
                    
                    // The lake of sadness
                    IslandLocationButton(
                        name: "The lake of sadness",
                        color: .blue
                    ) {
                        router.vm.manualMoodLabel = "Sad / Low"
                        withAnimation { router.checkInPage = 1 }
                    }
                    .offset(x: 60, y: 20)
                    
                    // The beach of enjoyment
                    IslandLocationButton(
                        name: "The beach of enjoyment",
                        color: .orange
                    ) {
                        router.vm.manualMoodLabel = "Energetic / Enthusiastic"
                        withAnimation { router.checkInPage = 1 }
                    }
                    .offset(x: 0, y: 100)
                }
                .padding()
                
                Spacer()
            }
        }
        .navigationTitle("Island Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IslandLocationButton: View {
    let name: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.caption.weight(.bold))
                .foregroundColor(.primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color, lineWidth: 2)
                )
                .shadow(radius: 3)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        EmotionMapIslandView()
            .environmentObject(AppRouter())
    }
}
