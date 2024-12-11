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
    private let size: CGFloat = 120

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
                options: [
                    .allowsTransparency,
                ],
                debugOptions: debugOptions
            )

            GeometryReader { proxy in
                BinView(isFull: false, size: 172)
                    .position(
                        x: scene.binPosition.x,
                        y: -scene.binPosition.y + proxy.size.height
                    )
                ForEach(0..<10) { i in
                    if let position = scene.trashPositions[safe: i] {
                        TrashView(status: .closed, size: size)
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
            scene.backgroundColor = .clear

            let node = SKShapeNode(circleOfRadius: 172 / 2)
            node.position = .init(x: 80, y: 0)
            node.physicsBody = SKPhysicsBody(circleOfRadius: 172 / 2)
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.isDynamic = false
            node.name = "Bin"
            node.strokeColor = .clear
            scene.addChild(node)
            scene.binPosition = node.position

            let width = Int(UIScreen.main.bounds.width * 0.9)
            let height = Int(UIScreen.main.bounds.height * 0.9)

            for i in (0..<10) {
                let position = CGPoint(x: Int.random(in: 0..<width), y: Int.random(in: 0..<height))
                let node = SKShapeNode(circleOfRadius: size / 2)
                node.position = position
                node.physicsBody = SKPhysicsBody(circleOfRadius: size / 2)
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
