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
    @State private var tasks: [DLTask] = DLTask.mocks.filter { !$0.isArchived }
    @State private var archivedTasks: [DLTask] = DLTask.mocks.filter { $0.isArchived }

    var body: some View {
        SpriteView(
            scene: scene,
            options: [.allowsTransparency]
        )
        .overlay {
            binView
        }
        .overlay {
            if tasks.isEmpty {
                noTaskMessageView
            } else {
                tasksView
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

    private var binView: some View {
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
    }

    private var noTaskMessageView: some View {
        Text("あとまわしリンクがありません")
            .font(.DL.title1)
            .foregroundStyle(Color.Semantic.Text.secondary)
    }

    private var tasksView: some View {
        ForEach(tasks) { task in
            if let position = scene.trashPositions[task.id.uuidString],
               let rotation = scene.trashRotations[task.id.uuidString] {
                taskView(
                    task,
                    position: scene.convertPoint(toView: position),
                    rotation: -rotation
                )
            }
        }
    }

    private func taskView(_ task: DLTask, position: CGPoint, rotation: CGFloat) -> some View {
        TrashView(task: task)
            .rotationEffect(.radians(rotation))
            .draggable(task)
            .contextMenu {
                if task.isCompleted || task.isArchived {
                    Button("未完了にする", systemImage: "square") {
                    }
                } else {
                    Button("完了にする", systemImage: "checkmark.square") {
                    }
                }
                Button("削除する", systemImage: "trash", role: .destructive) {
                }
            }
            .onTapGesture {
            }
            .position(position)
    }
}

#Preview {
    TrashMountainView()
}
