//
//  IMImmersiveIslandCrabView.swift
//  EmotionsMap
//
//  Created by Riccardo Puggioni on 20/02/26.
//


import SwiftUI
import RealityKit

@available(iOS 17.0, *)
struct IMImmersiveIslandCrabView: View {

    var onWake: () -> Void

    @State private var root: Entity?
    @State private var hasLoaded = false

    var body: some View {
        RealityView { content in

            guard !hasLoaded else { return }
            hasLoaded = true

            guard let url = Bundle.main.url(forResource: "ambientato_apertura", withExtension: "usdz") else {
                assertionFailure("❌ ambientato_apertura.usdz non trovato nel bundle")
                return
            }

            do {
                let entity = try await Entity(contentsOf: url)
                makeTappable(entity)
                root = entity
                content.add(entity)
            } catch {
                assertionFailure("❌ Errore caricamento USDZ: \(error)")
            }
        }
        .ignoresSafeArea()
        .gesture(
            TapGesture()
                .targetedToAnyEntity()
                .onEnded { _ in
                    onWake()
                    playWakeAnimation()
                }
        )
    }

    private func makeTappable(_ entity: Entity) {
        entity.generateCollisionShapes(recursive: true)
        entity.visit { e in
            e.components.set(InputTargetComponent())
            if e.components[CollisionComponent.self] == nil {
                e.generateCollisionShapes(recursive: false)
            }
        }
    }

    @MainActor
    private func playWakeAnimation() {
        guard let root else { return }
        let animatedEntity = findFirstAnimatedEntity(in: root) ?? root
        if let first = animatedEntity.availableAnimations.first {
            animatedEntity.playAnimation(first)
        }
    }

    private func findFirstAnimatedEntity(in entity: Entity) -> Entity? {
        if !entity.availableAnimations.isEmpty { return entity }
        for child in entity.children {
            if let found = findFirstAnimatedEntity(in: child) { return found }
        }
        return nil
    }
}

private extension Entity {
    func visit(_ block: (Entity) -> Void) {
        block(self)
        children.forEach { $0.visit(block) }
    }
}