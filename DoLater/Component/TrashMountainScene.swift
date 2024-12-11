//
//  TrashMountainScene.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Observation
import SpriteKit

@Observable
final class TrashMountainScene: SKScene {
    var trashPositions: [CGPoint] = (0..<10).map { _ in .init(x: 0, y: 0) }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        for i in (0..<10) {
            guard
                let node = childNode(withName: "Trash \(i)"),
                let _ = trashPositions[safe: i]
            else {
                continue
            }
            trashPositions[i] = node.position
        }
    }
}
