//
//  MockAuthRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseAuth

final actor MockAuthRepository: AuthRepositoryProtocol {
    init() {}

    func getCurrentUser() async throws -> FirebaseAuth.User {
        return .mock
    }

    func updateDisplayName(for user: FirebaseAuth.User, displayName: String) async throws {
    }

    func updatePhotoURL(for user: FirebaseAuth.User, photoURL: URL) async throws {
    }
}
