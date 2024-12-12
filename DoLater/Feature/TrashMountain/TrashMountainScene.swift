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

    func addBinNode(radius: CGFloat) {
        let node = SKShapeNode(circleOfRadius: radius)
        node.name = "bin"
        node.position = CGPoint(x: frame.minX + 80, y: frame.minY)
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        node.strokeColor = .clear
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false
        addChild(node)
        binPosition = node.position
    }

    func addTrashNode(task: DLTask) {
        let node = SKShapeNode(circleOfRadius: task.radius)
        node.name = task.id.uuidString
        node.position = CGPoint(x: frame.midX, y: frame.maxY - task.size - 40)
        node.physicsBody = SKPhysicsBody(circleOfRadius: task.radius)
        node.strokeColor = .clear
        addChild(node)
        trashPositions[task.id.uuidString] = node.position
        trashRotations[task.id.uuidString] = node.zRotation
    }
}
