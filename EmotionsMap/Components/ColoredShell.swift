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
            // Layer 1: emotion color fill, shaped to the shell silhouette
            Image(shapeName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(color)

            // Layer 2: grayscale shell texture — luminosity blend takes the
            // shading/luminance from the gray image and the hue+saturation
            // from the color layer beneath. drawingGroup() is required so the
            // two layers composite against each other in an offscreen pass
            // rather than against the whole scene background.
            Image(shellName)
                .resizable()
                .blendMode(.luminosity)
        }
        .drawingGroup()
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
