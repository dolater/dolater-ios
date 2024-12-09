//
//  PushNotificationRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseMessaging
import Foundation
import OpenAPIURLSession

protocol PushNotificationRepositoryProtocol: Actor {
    func getFCMToken() async throws -> String

    func postFCMToken(_ token: String, timestamp: Date) async throws
}

final actor PushNotificationRepositoryImpl: PushNotificationRepositoryProtocol {
    init() {}

    func getFCMToken() async throws -> String {
        try await Messaging.messaging().token()
    }

    func postFCMToken(_ token: String, timestamp: Date) async throws {
        do {
            let client = try await Client.build()
            let response = try await client.upsertFCMToken(
                .init(body: .json(.init(token: token, timestamp: timestamp))))
            switch response {
            case .noContent:
                return

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

            case .internalServerError(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.internalServerError, error.message)
                }
                throw RepositoryError.server(.internalServerError, nil)

            case .undocumented(let statusCode, let payload):
                throw RepositoryError.server(.init(rawValue: statusCode), payload)
            }
        } catch let error as RepositoryError {
            Logger.standard.error("RepositoryError: \(error.localizedDescription)")
            throw error
        } catch {
            Logger.standard.error("RepositoryError: \(error)")
            throw error
        }
    }
}
