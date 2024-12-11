//
//  TrashMountainView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SpriteKit
import SwiftUI

struct TrashMountainView: View {
    @State private var scene: TrashMountainScene = .init()
    private let debugOptions: SpriteView.DebugOptions

    init(isDebugEnabled: Bool = false) {
        debugOptions = isDebugEnabled ? [
            .showsDrawCount,
            .showsFPS,
            .showsFields,
            .showsNodeCount,
            .showsPhysics,
            .showsQuadCount,
        ] : []
    }

    var body: some View {
        ZStack {
            SpriteView(
                scene: scene,
                debugOptions: debugOptions
            )

            GeometryReader { proxy in
                ForEach(0..<10) { i in
                    if let position = scene.trashPositions[safe: i] {
                        TrashView()
                            .position(
                                x: position.x,
                                y: -position.y + proxy.size.height
                            )
                    }
                }
            }
        }
        .onAppear {
            scene.scaleMode = .resizeFill

            for i in (0..<10) {
                let radius = CGFloat(32)
                let position = CGPoint(x: 0, y: 400)
                let node = SKShapeNode(circleOfRadius: radius)
                node.position = position
                node.physicsBody = SKPhysicsBody(circleOfRadius: radius)
                node.name = "Trash \(i)"
                node.strokeColor = .clear
                scene.addChild(node)
                guard let _ = scene.trashPositions[safe: i] else {
                    continue
                }
                scene.trashPositions[i] = position
            }
        }
    }
}

#Preview {
    TrashMountainView(isDebugEnabled: false)
}
