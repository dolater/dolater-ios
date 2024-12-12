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
    @State private var tasks: [DLTask] = DLTask.mocks.filter { task in
        !task.isArchived
    }
    @State private var archivedTasks: [DLTask] = DLTask.mocks.filter { task in
        task.isArchived
    }

    var body: some View {
        SpriteView(
            scene: scene,
            options: [.allowsTransparency]
        )
        .overlay {
            BinView(isFull: !archivedTasks.isEmpty)
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
                    archivedTasks.append(contentsOf: droppedTasks)
                    return true
                }
                .position(scene.convertPoint(toView: scene.binPosition))

            ForEach(tasks) { task in
                if let position = scene.trashPositions[task.id.uuidString],
                   let rotation = scene.trashRotations[task.id.uuidString] {
                    TrashView(task: task)
                        .rotationEffect(.radians(-rotation))
                        .draggable(task)
                        .position(scene.convertPoint(toView: position))
                }
            }
        }
        .onAppear {
            scene.scaleMode = .resizeFill
            scene.backgroundColor = .clear

            scene.addBinNode(radius: 172 / 2)

            tasks.forEach { task in
                Task {
                    scene.addTrashNode(task: task)
                }
            }
        }
    }
}

#Preview {
    TrashMountainView()
}
