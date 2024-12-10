//
//  MockTaskRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

final actor MockTaskRepository: TaskRepositoryProtocol {
    init() {}

    func getTasks() async throws -> [Components.Schemas.Task] {
        [
            .mock1,
            .mock2,
            .mock3,
        ]
    }
    
    func createTask(_ task: Components.Schemas.CreateTaskInput) async throws -> Components.Schemas.Task {
        .mock1
    }
    
    func getTask(id: Components.Parameters.id) async throws -> Components.Schemas.Task {
        .mock1
    }
    
    func updateTask(_ task: Components.Schemas.UpdateTaskInput, id: Components.Parameters.id) async throws -> Components.Schemas.Task {
        var updatedTask = Components.Schemas.Task.mock1
        if let title = task.title {
            updatedTask.title = title
        }
        if let url = task.url {
            updatedTask.url = url
        }
        if let archivedAt = task.archivedAt {
            updatedTask.archivedAt = archivedAt
        }
        if let completedAt = task.completedAt {
            updatedTask.completedAt = completedAt
        }
        return updatedTask
    }

    func deleteTask(id: Components.Parameters.id) async throws {
    }
}
