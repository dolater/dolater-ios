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
}
