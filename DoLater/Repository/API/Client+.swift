//
//  APIServerClient.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation
import OpenAPIURLSession

extension Client {
    static func build() async throws -> Client {
        let string = try? await EnvironmentImpl.shared.localRepository.getString(
            for: .serverEnvironment)
        let environment = ServerEnvironment(rawValue: string ?? "") ?? .production
        return Client(
            serverURL: environment.apiServerURL,
            transport: URLSessionTransport(),
            middlewares: [AuthMiddleware()]
        )
    }
}
