//
//  EmotionMapIslandView.swift
//  EmotionsMap
//

import SwiftUI

// MARK: - Main view

struct EmotionMapIslandView: View {
    @EnvironmentObject private var router: AppRouter

    // Ordered clockwise from north: Joy(0°) Disgust(60°) Sadness(120°)
    //                               Anger(180°) Fear(240°) Surprise(300°)
    private let sectorData: [(emotion: BasicEmotion, icon: String)] = [
        (.joy,       "sun.max.fill"),
        (.disgusted, "moon.fill"),
        (.sadness,   "drop.fill"),
        (.anger,     "flame.fill"),
        (.fear,      "leaf.fill"),
        (.surprise,  "sparkles"),
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {

                // ── Background ──
                Image("IslandMap")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()

                // Subtle dark veil so text is legible
                Color.black.opacity(0.18).ignoresSafeArea()

                // ── Content stack ──
                VStack(spacing: 0) {

                    // Title
                    Text("where are you\non the island?")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.55), radius: 6)
                        .padding(.horizontal, 24)
                        .padding(.top, 60)

                    Spacer()

                    // Interactive circle
                    let diameter = min(geo.size.width - 40, geo.size.height * 0.52)
                    IslandCirclePicker(
                        diameter: diameter,
                        sectorData: sectorData,
                        pinAngle: $router.vm.pinAngle,
                        pinIntensity: $router.vm.pinIntensity
                    )

                    // Hint
                    Text("drag to explore")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.top, 10)

                    Spacer()

                    // CTA button
                    ctaButton
                        .padding(.horizontal, 28)
                        .padding(.bottom, 44)
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: – CTA button

    private var ctaButton: some View {
        let emotion = router.vm.basicEmotion
        return Button {
            withAnimation { router.checkInPage = 1 }
        } label: {
            Label(
                "get into the \(emotion.locationName.lowercased())",
                systemImage: "arrow.right.circle.fill"
            )
            .font(.system(.body, design: .rounded, weight: .semibold))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(Color(emotion.hexColor))
        .animation(.easeInOut(duration: 0.25), value: emotion)
    }
}

// MARK: - Interactive circle

private struct IslandCirclePicker: View {
    let diameter: CGFloat
    let sectorData: [(emotion: BasicEmotion, icon: String)]
    @Binding var pinAngle: Double
    @Binding var pinIntensity: Double

    private var radius: CGFloat { diameter / 2 }
    private var cx: CGFloat { radius }   // centre-x within the frame
    private var cy: CGFloat { radius }   // centre-y within the frame

    var body: some View {
        ZStack {

            // Glass background
            Circle()
                .fill(.ultraThinMaterial)
                .opacity(0.75)

            // Sector fills
            ForEach(Array(sectorData.enumerated()), id: \.offset) { idx, item in
                sectorPath(idx: idx)
                    .fill(Color(item.emotion.hexColor).opacity(0.38))
            }

            // Divider lines between sectors
            ForEach(0..<6, id: \.self) { idx in
                dividerPath(idx: idx)
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            }

            // Outer ring
            Circle()
                .stroke(Color.white.opacity(0.55), lineWidth: 2)

            // Mid-intensity dashed ring (visual guide)
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                .opacity(0.25)
                .foregroundStyle(.white)
                .frame(width: diameter * 0.5, height: diameter * 0.5)

            // Sector labels
            ForEach(Array(sectorData.enumerated()), id: \.offset) { idx, item in
                let angle = Double(idx) * 60.0
                let pos = point(angle: angle, distance: radius * 0.63)
                sectorLabel(item)
                    .position(pos)
            }

            // Pin (follows drag)
            let pDist = radius * CGFloat(max(0.04, pinIntensity))
            let pinPos = point(angle: pinAngle, distance: pDist)
            pin
                .position(pinPos)

            // Centre dot
            Circle()
                .fill(Color.white.opacity(0.8))
                .frame(width: 7, height: 7)
                .position(CGPoint(x: cx, y: cy))
        }
        .frame(width: diameter, height: diameter)
        .contentShape(Circle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { drag in
                    let dx = drag.location.x - cx
                    let dy = drag.location.y - cy
                    let dist = sqrt(dx * dx + dy * dy)
                    var angle = atan2(dx, -dy) * 180.0 / .pi
                    if angle < 0 { angle += 360.0 }
                    pinAngle    = angle
                    pinIntensity = min(dist / radius, 1.0)
                }
        )
    }

    // MARK: – Pin

    private var pin: some View {
        let emotion = BasicEmotion.from(angle: pinAngle)
        return ZStack {
            Circle()
                .fill(Color(emotion.hexColor))
                .saturation(0.15 + 0.85 * pinIntensity)
                .frame(width: 28, height: 28)
            Circle()
                .stroke(Color.white, lineWidth: 2.5)
                .frame(width: 28, height: 28)
        }
        .shadow(color: .black.opacity(0.3), radius: 5, y: 2)
    }

    // MARK: – Label

    private func sectorLabel(_ item: (emotion: BasicEmotion, icon: String)) -> some View {
        VStack(spacing: 3) {
            Image(systemName: item.icon)
                .font(.system(size: 13, weight: .semibold))
            Text(item.emotion.locationName)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .frame(width: 74)
                .lineLimit(2)
        }
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.55), radius: 2)
    }

    // MARK: – Geometry helpers

    /// Returns a point on the circle at `angle` degrees (0=top, CW) and `distance` from centre.
    private func point(angle: Double, distance: CGFloat) -> CGPoint {
        let rad = angle * .pi / 180.0
        return CGPoint(x: cx + distance * CGFloat(sin(rad)),
                       y: cy - distance * CGFloat(cos(rad)))
    }

    /// Pie-slice path for sector `idx`. Each sector is 60° wide, offset so
    /// sector 0 (Joy) is centred on 0° (top).
    private func sectorPath(idx: Int) -> Path {
        let startAngle = Double(idx) * 60.0 - 30.0
        let endAngle   = startAngle + 60.0
        return arc(from: startAngle, to: endAngle, closed: true)
    }

    /// Radial line at the boundary between sectors.
    private func dividerPath(idx: Int) -> Path {
        let angle = Double(idx) * 60.0 - 30.0
        var path = Path()
        path.move(to: CGPoint(x: cx, y: cy))
        path.addLine(to: point(angle: angle, distance: radius))
        return path
    }

    /// Builds an arc (optionally closed back to centre) using line-segment
    /// approximation — no reliance on `addArc` coordinate-system quirks.
    private func arc(from startAngle: Double, to endAngle: Double, closed: Bool) -> Path {
        var path = Path()
        let steps = 60
        path.move(to: closed ? CGPoint(x: cx, y: cy) : point(angle: startAngle, distance: radius))
        for i in 0...steps {
            let t     = Double(i) / Double(steps)
            let angle = startAngle + t * (endAngle - startAngle)
            path.addLine(to: point(angle: angle, distance: radius))
        }
        if closed {
            path.addLine(to: CGPoint(x: cx, y: cy))
            path.closeSubpath()
        }
        return path
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EmotionMapIslandView()
            .environmentObject(AppRouter())
    }
}
