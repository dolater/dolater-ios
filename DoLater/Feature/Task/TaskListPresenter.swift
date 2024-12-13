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
        var activeTasks: [DLTask] = []
        var renderedTasks: [DLTask] = []
        var removedTasks: [DLTask] = []
        var getActiveTasksStatus: DataStatus = .default
        var getRemovedTasksStatus: DataStatus = .default
        var updateTaskStatus: DataStatus = .default

        enum Path: Hashable {
            case detail(DLTask)
            case bin
        }
    }

    enum Action {
        case onAppear
        case onTasksDropped([DLTask], CGPoint)
        case onBinTapped
        case onTaskTapped(DLTask)
        case onMarkAsCompletedButtonTapped(DLTask)
        case onMarkAsToDoButtonTapped(DLTask)
        case onDeleteButtonTapped(DLTask)
    }

    var state: State

    private let taskService: TaskService<Environment> = .init()

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

        case .onTaskTapped(let task):
            await onTaskTapped(task)

        case .onMarkAsCompletedButtonTapped(let task):
            await onMarkAsCompletedButtonTapped(task)

        case .onMarkAsToDoButtonTapped(let task):
            await onMarkAsToDoButtonTapped(task)

        case .onDeleteButtonTapped(let task):
            await onDeleteButtonTapped(task)
        }
    }
}

private extension TaskListPresenter {
    func onAppear() async {
        do {
            state.getActiveTasksStatus = .loading
            state.activeTasks = try await taskService.getActiveTasks()
            state.getActiveTasksStatus = .loaded
        } catch {
            state.getActiveTasksStatus = .failed(.init(error))
        }

        do {
            state.getRemovedTasksStatus = .loading
            state.removedTasks = try await taskService.getActiveTasks()
            state.getRemovedTasksStatus = .loaded
        } catch {
            state.getRemovedTasksStatus = .failed(.init(error))
        }

        if state.activeTasks != state.renderedTasks {
            await refreshNodes()
        }
    }

    func onTasksDropped(_ droppedTasks: [DLTask], at droppedPoint: CGPoint) async {
        for task in droppedTasks {
            do {
                state.updateTaskStatus = .loading
                let updatedTask = try await taskService.remove(taskId: task.id)
                state.updateTaskStatus = .loaded
            } catch {
                state.updateTaskStatus = .failed(.init(error))
            }
        }
        let nodes = droppedTasks.compactMap { task in
            state.scene.childNode(withName: task.displayName)
        }
        state.scene.removeChildren(in: nodes)
        state.activeTasks.removeAll(where: { task in
            droppedTasks.contains { droppedTask in
                droppedTask.id == task.id
            }
        })
        state.removedTasks.append(contentsOf: droppedTasks)
    }

    func onBinTapped() async {
        state.path.append(State.Path.bin)
    }

    func onTaskTapped(_ task: DLTask) async {
        state.path.append(State.Path.detail(task))
    }

    func onMarkAsCompletedButtonTapped(_ task: DLTask) async {
        do {
            state.updateTaskStatus = .loading
            let updatedTask = try await taskService.markAsCompleted(taskId: task.id)
            state.activeTasks.removeAll(where: { $0.id == task.id })
            state.activeTasks.append(updatedTask)
            state.activeTasks.sort { $0.createdAt < $1.createdAt }
            state.updateTaskStatus = .loaded
        } catch {
            state.updateTaskStatus = .failed(.init(error))
        }
    }

    func onMarkAsToDoButtonTapped(_ task: DLTask) async {
        do {
            state.updateTaskStatus = .loading
            let updatedTask = try await taskService.markAsToDo(taskId: task.id)
            state.activeTasks.removeAll(where: { $0.id == task.id })
            state.activeTasks.append(updatedTask)
            state.activeTasks.sort { $0.createdAt < $1.createdAt }
            state.updateTaskStatus = .loaded
        } catch {
            state.updateTaskStatus = .failed(.init(error))
        }
    }

    func onDeleteButtonTapped(_ task: DLTask) async {
        do {
            state.updateTaskStatus = .loading
            try await taskService.delete(taskId: task.id)
            state.activeTasks.removeAll(where: { $0.id == task.id })
            state.scene.removeTrashNode(for: task)
            state.updateTaskStatus = .loaded
        } catch {
            state.updateTaskStatus = .failed(.init(error))
        }
    }
}

private extension TaskListPresenter {
    func refreshNodes() async {
        state.scene.removeBinNode()
        state.scene.removeTrashNodes()
        state.scene.addBinNode(radius: 172 / 2)
        state.renderedTasks = []
        state.activeTasks.forEach { task in
            state.scene.addTrashNode(for: task)
            state.renderedTasks.append(task)
        }
        state.scene.addShakeAction()
    }
}
