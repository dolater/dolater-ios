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
    var binPosition: CGPoint = .init(x: 0, y: 0)
    var trashPositions: [String:CGPoint] = [:]
    var trashRotations: [String:CGFloat] = [:]

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if let node = childNode(withName: "bin") {
            binPosition = node.position
        }
        children.forEach { node in
            if let name = node.name {
                trashPositions[name] = node.position
                trashRotations[name] = node.zRotation
            }
        }
    }
}
