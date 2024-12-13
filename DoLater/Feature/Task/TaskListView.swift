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
    private let debugOptions: SpriteView.DebugOptions

    init(path: Binding<NavigationPath>, isDebugMode: Bool = false) {
        _path = path
        presenter = .init(path: path.wrappedValue)
        debugOptions = isDebugMode ? [
            .showsDrawCount,
            .showsFields,
            .showsFPS,
            .showsNodeCount,
            .showsPhysics,
            .showsQuadCount,
        ] : []
    }

    var body: some View {
        SpriteView(
            scene: presenter.state.scene,
            options: [.allowsTransparency],
            debugOptions: debugOptions
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
            if let position = presenter.state.scene.trashPositions[task.displayName],
               let rotation = presenter.state.scene.trashRotations[task.displayName] {
                taskView(
                    task,
                    position: presenter.state.scene.convertPoint(toView: position),
                    rotation: -rotation
                )
            }
        }
    }

    private func taskView(_ task: DLTask, position: CGPoint, rotation: CGFloat) -> some View {
        TaskItemView(task: task, rotationAngle: .radians(rotation)) {
            presenter.dispatch(.onMarkAsCompletedButtonTapped(task))
        } onMarkAsToDo: {
            presenter.dispatch(.onMarkAsToDoButtonTapped(task))
        } onDelete: {
            presenter.dispatch(.onDeleteButtonTapped(task))
        }
        .draggable(task)
        .onTapGesture {
            presenter.dispatch(.onTaskTapped(task))
        }
        .position(position)
    }
}

#Preview {
    @Previewable @State var path: NavigationPath = .init()

    NavigationStack {
        TaskListView<MockEnvironment>(path: $path, isDebugMode: true)
    }
}
