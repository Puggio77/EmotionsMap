//
//  SpriteAnimationView.swift
//  EmotionsMap
//

import SwiftUI

/// Displays a single frame from a sprite sheet, or plays through all frames once.
///
/// The sheet is laid out left-to-right, top-to-bottom.
/// - `startFrame`: which frame to show initially (0 = first, rows×cols−1 = last)
/// - `playAnimation`: if true, advances from `startFrame` to the last frame, then calls `onComplete`
struct SpriteAnimationView: View {
    let imageName: String
    let rows: Int
    let cols: Int
    let fps: Double
    let startFrame: Int
    let playAnimation: Bool
    let onComplete: () -> Void

    @State private var currentFrame: Int

    init(
        imageName: String,
        rows: Int,
        cols: Int,
        fps: Double = 12,
        startFrame: Int = 0,
        playAnimation: Bool = false,
        onComplete: @escaping () -> Void = {}
    ) {
        self.imageName    = imageName
        self.rows         = rows
        self.cols         = cols
        self.fps          = fps
        self.startFrame   = startFrame
        self.playAnimation = playAnimation
        self.onComplete   = onComplete
        _currentFrame     = State(initialValue: startFrame)
    }

    private var totalFrames: Int { rows * cols }

    var body: some View {
        GeometryReader { geo in
            let col = currentFrame % cols
            let row = currentFrame / cols

            Image(imageName)
                .resizable()
                .frame(
                    width:  geo.size.width  * CGFloat(cols),
                    height: geo.size.height * CGFloat(rows)
                )
                .offset(
                    x: -geo.size.width  * CGFloat(col),
                    y: -geo.size.height * CGFloat(row)
                )
        }
        // ↑ .clipped() must be OUTSIDE GeometryReader so it clips to the
        //   container bounds, not to the oversized image layout frame.
        .clipped()
        .task {
            guard playAnimation else { return }
            let delay = UInt64(1_000_000_000.0 / fps)
            for frame in (startFrame + 1)..<totalFrames {
                try? await Task.sleep(nanoseconds: delay)
                currentFrame = frame
            }
            try? await Task.sleep(nanoseconds: delay)
            onComplete()
        }
    }
}
