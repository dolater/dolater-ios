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
    @State private var tasks: [DLTask] = DLTask.mocks

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
                BinView(isFull: false)
                    .position(
                        x: scene.binPosition.x,
                        y: -scene.binPosition.y + proxy.size.height
                    )
                    .dropDestination(for: DLTask.self) { droppedTasks, _ in
                        let nodes = droppedTasks.compactMap { task in
                            scene.childNode(withName: task.id.uuidString)
                        }
                        scene.removeChildren(in: nodes)
                        tasks.removeAll(where: { task in
                            droppedTasks.contains { droppedTask in
                                droppedTask.id == task.id
                            }
                        })
                        return true
                    } isTargeted: { task in
                    }
                ForEach(tasks) { task in
                    if let position = scene.trashPositions[task.id.uuidString],
                       let rotation = scene.trashRotations[task.id.uuidString] {
                        TrashView(task: task, size: size)
                            .rotationEffect(.radians(rotation))
                            .position(
                                x: position.x,
                                y: -position.y + proxy.size.height
                            )
                            .draggable(task) {
                                TrashView(task: task, size: size)
                                    .rotationEffect(.radians(rotation))
                            }
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
            node.name = "bin"
            node.strokeColor = .clear
            scene.addChild(node)
            scene.binPosition = node.position

            let width = Int(UIScreen.main.bounds.width * 0.8)
            let height = Int(UIScreen.main.bounds.height * 0.8)

            tasks.forEach { task in
                let position = CGPoint(x: Int.random(in: 0..<width), y: Int.random(in: 0..<height))
                let node = SKShapeNode(circleOfRadius: size / 2)
                node.position = position
                node.physicsBody = SKPhysicsBody(circleOfRadius: size / 2)
                node.name = task.id.uuidString
                node.strokeColor = .clear
                scene.addChild(node)
                scene.trashPositions[task.id.uuidString] = position
                scene.trashRotations[task.id.uuidString] = 0
            }
        }
    }
}

#Preview {
    TrashMountainView(isDebugEnabled: false)
}
