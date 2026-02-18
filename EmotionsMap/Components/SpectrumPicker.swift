//
//  SpectrumPicker.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 17/02/26.
//

import SwiftUI

struct SpectrumPicker: View {
    @Binding var x: Double // 0...1
    @Binding var y: Double // 0...1

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.secondary, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.quaternary.opacity(0.6))
                    )

                // assi (facoltativi)
                Path { p in
                    p.move(to: CGPoint(x: 0, y: size/2))
                    p.addLine(to: CGPoint(x: size, y: size/2))
                    p.move(to: CGPoint(x: size/2, y: 0))
                    p.addLine(to: CGPoint(x: size/2, y: size))
                }
                .stroke(.secondary.opacity(0.4), lineWidth: 1)

                // punto
                Circle()
                    .frame(width: 18, height: 18)
                    .position(
                        x: CGFloat(x) * size,
                        y: CGFloat(1 - y) * size // invertiamo y: su = 1
                    )
                    .shadow(radius: 2)
            }
            .frame(width: size, height: size)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let px = max(0, min(value.location.x, size))
                        let py = max(0, min(value.location.y, size))
                        x = Double(px / size)
                        y = Double(1 - (py / size))
                    }
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
