//
//  MockMessagingRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

final actor MockMessagingRepository: MessagingRepositoryProtocol {
    init() {}

    func getFCMToken() async throws -> String {
        ""
    }

    func postFCMToken(_ token: String, timestamp: Date) async throws {
    }
}
