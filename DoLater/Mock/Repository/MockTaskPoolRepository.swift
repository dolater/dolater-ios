//
//  MockTaskPoolRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

final actor MockTaskPoolRepository: TaskPoolRepositoryProtocol {
    func getPools() async throws -> [Components.Schemas.TaskPool] {
        [
            .mock1,
            .mock2,
            .mock3,
        ]
    }
    
    func createPool() async throws -> Components.Schemas.TaskPool {
        .mock1
    }
    
    func getPool(id: Components.Parameters.id) async throws -> Components.Schemas.TaskPool {
        .mock1
    }
    
    func deletePool(id: Components.Parameters.id) async throws {
    }
}
