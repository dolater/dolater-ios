//
//  TaskService.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Foundation
import SwiftUI

final actor TaskService<Environment: EnvironmentProtocol> {
    init() {}

    func getActiveTasks() async throws -> [DLTask] {
        let taskPools = try await Environment.shared.taskPoolRepository.getPools()
        guard let activePool = taskPools.first(where: { $0._type == .active }) else {
            return []
        }
        let tasks = try await Environment.shared.taskRepository.getTasks(poolId: activePool.id)
        return tasks.sorted { $0.createdAt > $1.createdAt }
    }

    func getRemovedTasks() async throws -> [DLTask] {
        let taskPools = try await Environment.shared.taskPoolRepository.getPools()
        guard let binPool = taskPools.first(where: { $0._type == .bin }) else {
            return []
        }
        return try await Environment.shared.taskRepository.getTasks(poolId: binPool.id)
    }

    func addTask(task: Components.Schemas.CreateTaskInput) async throws -> DLTask {
        try await Environment.shared.taskRepository.createTask(task)
    }

    func markAsCompleted(taskId: String) async throws -> DLTask {
        try await Environment.shared.taskRepository.updateTask(
            .init(completedAt: .now),
            id: taskId
        )
    }

    func markAsToDo(taskId: String) async throws -> DLTask {
        try await Environment.shared.taskRepository.updateTask(
            .init(completedAt: nil),
            id: taskId
        )
    }

    func remove(taskId: String) async throws -> DLTask {
        try await Environment.shared.taskRepository.updateTask(
            .init(removedAt: .now),
            id: taskId
        )
    }

    func archive() async throws -> [DLTask] {
        let tasks = try await getRemovedTasks()
        return await withTaskGroup(of: DLTask?.self, returning: [DLTask].self) { group in
            tasks.forEach { task in
                group.addTask {
                    try? await Environment.shared.taskRepository.updateTask(
                        .init(removedAt: .now),
                        id: task.id
                    )
                }
            }

            var result: [DLTask?] = []
            for await task in group {
                result.append(task)
            }
            let successfulTaskIds = result.compactMap({ $0?.id })
            return tasks.filter { task in
                !successfulTaskIds.contains(task.id)
            }
        }
    }

    func delete(taskId: String) async throws {
        try await Environment.shared.taskRepository.deleteTask(id: taskId)
    }
}
