//
//  MockAccountRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseAuth

final actor MockAccountRepository: AccountRepositoryProtocol {
    func getCurrentUser() async throws -> FirebaseAuth.User {
        guard let user = User.mock else {
            throw AccountRepositoryError.unauthenticated
        }
        return user
    }

    func updateDisplayName(for user: FirebaseAuth.User, displayName: String) async throws {
    }

    func updatePhotoURL(for user: FirebaseAuth.User, photoURL: URL) async throws {
    }
}
