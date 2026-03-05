//
//  EmotionDetailView.swift
//  EmotionsMap
//
//  Created by Lanzoni Nicola on 20/05/2024.
//

import SwiftUI

struct EmotionDetailView: View {
    @EnvironmentObject private var router: AppRouter

    @State private var emotions: [SpecificEmotionItem] = []
    @State private var shellPositions: [CGPoint] = []
    @State private var revealedEmotions: Set<String> = []
    @State private var selectedEmotion: SpecificEmotionItem? = nil

    private static let tileWidth: CGFloat = 6827
    private let tileCount = 3

    private var items: [SpecificEmotionItem] {
        SpecificEmotionItem.items(for: router.vm.basicEmotion)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // ── Infinite Scroll Shore ──
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .topLeading) {
                        // 3 seamlessly tiled copies of the background
                        HStack(spacing: 0) {
                            ForEach(0..<tileCount, id: \.self) { _ in
                                Image("shore_1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: Self.tileWidth, height: geo.size.height)
                                    .clipped()
                            }
                        }

                        // Shells replicated across all 3 tiles
                        ForEach(0..<tileCount, id: \.self) { tile in
                            ForEach(Array(emotions.enumerated()), id: \.offset) { index, emotion in
                                if index < shellPositions.count {
                                    let basePos = shellPositions[index]
                                    ShellView(
                                        emotion: emotion,
                                        isRevealed: revealedEmotions.contains(emotion.name),
                                        isSelected: selectedEmotion == emotion,
                                        color: Color(router.vm.basicEmotion.hexColor)
                                    )
                                    .position(
                                        x: CGFloat(tile) * Self.tileWidth + basePos.x,
                                        y: basePos.y
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            revealedEmotions.insert(emotion.name)
                                            selectedEmotion = emotion
                                        }
                                    }
                                }
                            }
                        }

                        // Invisible probe — sets initial offset and handles seamless looping
                        ScrollLooper(tileWidth: Self.tileWidth)
                            .frame(width: 1, height: 1)
                    }
                    .frame(width: Self.tileWidth * CGFloat(tileCount), height: geo.size.height)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring()) { selectedEmotion = nil }
                    }
                }
                .ignoresSafeArea()

                // ── Header overlay (top-left) ──
                VStack(alignment: .leading, spacing: 8) {
                    Text("recognise your emotion")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(Color(red: 0.35, green: 0.28, blue: 0.24))

                    let subheadline = selectedEmotion != nil ? "this is how you feel — or keep exploring" : "tap a shell to find out what's inside"
                    Text(subheadline)
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.34))
                        .animation(.easeInOut(duration: 0.2), value: selectedEmotion)

                    if let emotion = selectedEmotion {
                        Text(emotion.description)
                            .font(.system(.footnote, design: .rounded, weight: .regular))
                            .foregroundStyle(Color(red: 0.25, green: 0.20, blue: 0.17))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(red: 241/255, green: 228/255, blue: 211/255).opacity(0.92))
                            )
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: selectedEmotion)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 28)
                .padding(.top, 56)

                // ── Confirm button ──
                if let emotion = selectedEmotion {
                    Button {
                        router.vm.specificEmotion = emotion.name
                        var transaction = Transaction(animation: .default)
                        transaction.disablesAnimations = false
                        withTransaction(transaction) { router.checkInPage = 2 }
                    } label: {
                        Label("Choose \"\(emotion.name)\"", systemImage: "checkmark.circle.fill")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(Color(red: 0.35, green: 0.28, blue: 0.24))
                    .foregroundStyle(Color(red: 241/255, green: 228/255, blue: 211/255))
                    .padding(.horizontal, 28)
                    .padding(.bottom, 32)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
            .onAppear {
                setupShells(viewHeight: geo.size.height)
            }
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
    }

    private func setupShells(viewHeight: CGFloat) {
        let shuffled = items.shuffled()
        self.emotions = shuffled
        self.shellPositions = generateShellPositions(for: shuffled.count, viewHeight: viewHeight)
    }

    private func generateShellPositions(for count: Int, viewHeight: CGFloat) -> [CGPoint] {
        guard count > 0 else { return [] }

        // Place shells in the sand zone — roughly the lower half of the shore view
        let sandTop = viewHeight * 0.52
        let sandBottom = viewHeight * 0.88

        let edgePadding: CGFloat = 300
        let availableWidth = Self.tileWidth - edgePadding * 2
        let spacing = availableWidth / CGFloat(count)

        return (0..<count).map { i in
            let baseX = edgePadding + CGFloat(i) * spacing + spacing / 2
            let jitter = CGFloat.random(in: -spacing * 0.3...spacing * 0.3)
            let x = max(edgePadding, min(Self.tileWidth - edgePadding, baseX + jitter))
            let y = CGFloat.random(in: sandTop...sandBottom)
            return CGPoint(x: x, y: y)
        }
    }
}


struct ShellView: View {
    let emotion: SpecificEmotionItem
    let isRevealed: Bool
    let isSelected: Bool
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            ColoredShell(shellName: emotion.shellName, color: color)
                .frame(width: 80, height: 80)
                .shadow(
                    color: isSelected ? color.opacity(0.75) : .black.opacity(0.25),
                    radius: isSelected ? 16 : 4,
                    x: 0, y: isSelected ? 0 : 2
                )

            if isRevealed {
                Text(emotion.name)
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.black.opacity(0.3))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .scaleEffect(isSelected ? 1.15 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
    }
}

/// Embedded invisibly inside a SwiftUI ScrollView.
/// Walks up the view hierarchy to find the underlying UIScrollView, then:
///   - Sets contentOffset to the center tile on first appearance
///   - Uses KVO to detect scroll position and loop seamlessly between tiles
private struct ScrollLooper: UIViewRepresentable {
    let tileWidth: CGFloat

    func makeCoordinator() -> Coordinator { Coordinator(tileWidth: tileWidth) }

    func makeUIView(context: Context) -> UIView {
        let probe = UIView()
        probe.isHidden = true
        DispatchQueue.main.async { context.coordinator.attach(to: probe) }
        return probe
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    final class Coordinator: NSObject {
        let tileWidth: CGFloat
        private weak var scrollView: UIScrollView?
        private var kvoToken: NSKeyValueObservation?
        private var isAdjusting = false

        init(tileWidth: CGFloat) { self.tileWidth = tileWidth }

        func attach(to probe: UIView) {
            var view: UIView? = probe.superview
            while let v = view {
                if let sv = v as? UIScrollView {
                    scrollView = sv
                    sv.contentOffset = CGPoint(x: tileWidth, y: 0)
                    kvoToken = sv.observe(\.contentOffset, options: [.new]) { [weak self] sv, _ in
                        self?.loop(sv)
                    }
                    break
                }
                view = v.superview
            }
        }

        private func loop(_ sv: UIScrollView) {
            guard !isAdjusting else { return }
            let x = sv.contentOffset.x
            let target: CGFloat?
            if x < tileWidth * 0.5 { target = x + tileWidth }
            else if x > tileWidth * 1.5 { target = x - tileWidth }
            else { target = nil }
            if let t = target {
                isAdjusting = true
                sv.contentOffset.x = t
                isAdjusting = false
            }
        }

        deinit { kvoToken?.invalidate() }
    }
}

extension SpecificEmotionItem {
    var shellName: String {
        let shellCount = 5 // We have shell_1 to shell_5
        // Use the hash of the name to get a stable but "random" shell index
        let hash = abs(name.hashValue)
        let index = (hash % shellCount) + 1
        return "shell_\(index)"
    }
}

#Preview {
    NavigationStack {
        EmotionDetailView()
            .environmentObject({
                let r = AppRouter()
                r.vm.manualMoodLabel = "Surprised / Amazed"
                return r
            }())
    }
}

