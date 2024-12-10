//
//  DebugService.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

final actor DebugService<Environment: EnvironmentProtocol> {
    func getServerEnvironment() async -> ServerEnvironment {
        let string = try? await Environment.shared.localRepository.getString(
            for: .serverEnvironment)
        return .init(rawValue: string ?? "") ?? .production
    }

    func setServerEnvironment(_ serverEnvironment: ServerEnvironment) async throws {
        try await Environment.shared.localRepository.setString(
            serverEnvironment.rawValue, for: .serverEnvironment)
    }

    func getAppCheckToken() async throws -> String {
        try await Environment.shared.appCheckRepository.getAppCheckToken()
    }

    func getFCMToken() async throws -> String {
        try await Environment.shared.messagingRepository.getFCMToken()
    }

    func getIdToken() async throws -> String {
        let user = try await Environment.shared.authRepository.getCurrentUser()
        return try await user.getIDToken(forcingRefresh: true)
    }
}
