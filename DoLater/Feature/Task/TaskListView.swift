//
//  TaskListView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SpriteKit
import SwiftUI

struct TaskListView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: TaskListPresenter<Environment>
    @Binding private var path: NavigationPath

    init(path: Binding<NavigationPath>) {
        _path = path
        presenter = .init(path: path.wrappedValue)
    }

    var body: some View {
        SpriteView(
            scene: presenter.state.scene,
            options: [.allowsTransparency]
        )
        .overlay {
            binView
        }
        .overlay {
            if presenter.state.tasks.isEmpty {
                noTaskMessageView
            } else {
                tasksView
            }
        }
        .task {
            await presenter.dispatch(.onAppear)
        }
        .sync($path, $presenter.state.path)
    }

    private var binView: some View {
        BinView(isFull: !presenter.state.archivedTasks.isEmpty)
            .dropDestination(for: DLTask.self) { droppedTasks, droppedPoint in
                presenter.dispatch(.onTasksDropped(droppedTasks, droppedPoint))
                return true
            }
            .onTapGesture {
                presenter.dispatch(.onBinTapped)
            }
            .position(presenter.state.scene.convertPoint(toView: presenter.state.scene.binPosition))
    }

    private var noTaskMessageView: some View {
        Text("あとまわしリンクがありません")
            .font(.DL.title1)
            .foregroundStyle(Color.Semantic.Text.secondary)
    }

    private var tasksView: some View {
        ForEach(presenter.state.tasks) { task in
            if let position = presenter.state.scene.trashPositions["trash_\(task.id.uuidString)"],
               let rotation = presenter.state.scene.trashRotations["trash_\(task.id.uuidString)"] {
                taskView(
                    task,
                    position: presenter.state.scene.convertPoint(toView: position),
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
                presenter.dispatch(.onTrashTapped(task))
            }
            .position(position)
    }
}

#Preview {
    @Previewable @State var path: NavigationPath = .init()

    NavigationStack {
        TaskListView<MockEnvironment>(path: $path)
    }
}
