//
//  SpectrumPicker.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI

struct SpectrumPicker: View {
    @Binding var x: Double  // 0…1  (left → right)
    @Binding var y: Double  // 0…1  (bottom → top)

    var body: some View {
        GeometryReader { geo in
            let size   = min(geo.size.width, geo.size.height)
            let radius = size / 2
            let center = CGPoint(x: radius, y: radius)

            // Pixel position of the current point
            let dotX = CGFloat(x) * size
            let dotY = CGFloat(1 - y) * size

            ZStack {

                // ── Background circle with quadrant gradient ──────────
                Circle()
                    .fill(
                        AngularGradient(
                            colors: [
                                Color.orange.opacity(0.25),   // top-left  (Anxious)
                                Color.yellow.opacity(0.25),   // top-right (Energetic)
                                Color.green.opacity(0.25),    // bottom-right (Calm)
                                Color.indigo.opacity(0.25),   // bottom-left (Sad)
                                Color.orange.opacity(0.25)    // wrap back
                            ],
                            center: .center
                        )
                    )

                Circle()
                    .strokeBorder(.secondary.opacity(0.4), lineWidth: 1)

                // ── Cross axes clipped to circle ──────────────────────
                Path { p in
                    p.move(to: CGPoint(x: 0,    y: radius))
                    p.addLine(to: CGPoint(x: size, y: radius))
                    p.move(to: CGPoint(x: radius, y: 0))
                    p.addLine(to: CGPoint(x: radius, y: size))
                }
                .stroke(.secondary.opacity(0.35), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                .clipShape(Circle())

                // ── Axis labels ───────────────────────────────────────
                // Top
                Text("High energy")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .position(x: radius, y: 10)

                // Bottom
                Text("Low energy")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .position(x: radius, y: size - 10)

                // Left
                Text("Unpleasant")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(-90))
                    .position(x: 18, y: radius)

                // Right
                Text("Pleasant")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(90))
                    .position(x: size - 18, y: radius)

                // ── Dot ───────────────────────────────────────────────
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 20, height: 20)
                    .shadow(color: Color.accentColor.opacity(0.5), radius: 6, y: 2)
                    .position(x: dotX, y: dotY)
            }
            .frame(width: size, height: size)
            .contentShape(Circle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // Vector from circle center to touch
                        let dx = value.location.x - center.x
                        let dy = value.location.y - center.y
                        let dist = sqrt(dx * dx + dy * dy)

                        let px: CGFloat
                        let py: CGFloat

                        if dist <= radius {
                            // Inside circle — use directly
                            px = value.location.x
                            py = value.location.y
                        } else {
                            // Outside — clamp to circle edge
                            let angle = atan2(dy, dx)
                            px = center.x + radius * cos(angle)
                            py = center.y + radius * sin(angle)
                        }

                        x = Double(px / size)
                        y = Double(1 - py / size)
                    }
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    @Previewable @State var x = 0.5
    @Previewable @State var y = 0.5
    SpectrumPicker(x: $x, y: $y)
        .padding(40)
}
