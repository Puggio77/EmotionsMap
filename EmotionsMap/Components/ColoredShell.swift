//
//  ColoredShell.swift
//  EmotionsMap
//

import SwiftUI

/// Renders a shell with an emotion color.
///
/// Requires two assets per shell index in the asset catalog:
///   - `shell_N`       — the texture/outline image (dark lines on white)
///   - `shell_N_shape` — the white silhouette (transparent background, white fill)
///
/// The silhouette is filled with the emotion color. The texture layer sits on top
/// with `.multiply` blend mode so its white areas disappear and only the dark
/// outlines/shading remain visible over the color.
struct ColoredShell: View {
    let shellName: String   // e.g. "shell_1"
    let color: Color

    private var shapeName: String { shellName + "_shape" }

    var body: some View {
        ZStack {
            // Layer 1: flat emotion color fill
            Image(shapeName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(color)

            // Layer 2: texture/outline — white areas become transparent via multiply
            Image(shellName)
                .resizable()
                .blendMode(.multiply)
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        ColoredShell(shellName: "shell_1", color: Color("F9C74F"))
            .frame(width: 120, height: 120)
        ColoredShell(shellName: "shell_1", color: Color("4A90D9"))
            .frame(width: 120, height: 120)
        ColoredShell(shellName: "shell_1", color: Color("E63946"))
            .frame(width: 120, height: 120)
    }
    .padding()
    .background(Color.gray.opacity(0.3))
}
