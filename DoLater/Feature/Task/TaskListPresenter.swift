//
//  TaskListPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import Observation
import SwiftUI

@Observable
final class TaskListPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Equatable {
        var path: NavigationPath
        var scene: TrashMountainScene
        var tasks: [DLTask] = DLTask.mocks.filter { !$0.isArchived }
        var archivedTasks: [DLTask] = DLTask.mocks.filter { $0.isArchived }

        enum Path: Hashable {
            case detail(DLTask)
            case bin
        }
    }

    enum Action {
        case onAppear
        case onTasksDropped([DLTask], CGPoint)
        case onBinTapped
        case onTrashTapped(DLTask)
    }

    var state: State

    init(path: NavigationPath) {
        let scene = TrashMountainScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        state = .init(path: path, scene: scene)
    }

    func dispatch(_ action: Action) {
        Task {
            await dispatch(action)
        }
    }

    func dispatch(_ action: Action) async {
        switch action {
        case .onAppear:
            await onAppear()

        case .onTasksDropped(let droppedTasks, let droppedPoint):
            await onTasksDropped(droppedTasks, at: droppedPoint)

        case .onBinTapped:
            await onBinTapped()

        case .onTrashTapped(let task):
            await onTrashTapped(task)
        }
    }
}

private extension TaskListPresenter {
    func onAppear() async {
        if state.scene.children.filter({ child in
            child.name?.hasPrefix("trash_") ?? false
        }).count != state.tasks.count {
            await refreshNodes()
        }
    }

    func onTasksDropped(_ droppedTasks: [DLTask], at droppedPoint: CGPoint) async {
        let nodes = droppedTasks.compactMap { task in
            state.scene.childNode(withName: task.id.uuidString)
        }
        state.scene.removeChildren(in: nodes)
        state.tasks.removeAll(where: { task in
            droppedTasks.contains { droppedTask in
                droppedTask.id == task.id
            }
        })
        state.archivedTasks.append(contentsOf: droppedTasks)
    }

    func onBinTapped() async {
        state.path.append(State.Path.bin)
    }

    func onTrashTapped(_ task: DLTask) async {
        state.path.append(State.Path.detail(task))
    }
}

private extension TaskListPresenter {
    func refreshNodes() async {
        state.scene.removeBinNode()
        state.scene.removeTrashNodes()
        state.scene.addBinNode(radius: 172 / 2)
        state.tasks.forEach { task in
            state.scene.addTrashNode(task: task)
        }
    }
}
