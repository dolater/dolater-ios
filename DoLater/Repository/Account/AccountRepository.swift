//
//  AccountRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/5/24.
//

import FirebaseAuth

protocol AccountRepositoryProtocol: Actor {
    func getCurrentUser() async throws -> User

    func updateDisplayName(for user: User, displayName: String) async throws

    func updatePhotoURL(for user: User, photoURL: URL) async throws
}

final actor AccountRepositoryImpl: AccountRepositoryProtocol {
    func getCurrentUser() async throws -> User {
        guard let user = Auth.auth().currentUser else {
            throw AccountRepositoryError.unauthenticated
        }
        return user
    }

    func updateDisplayName(for user: User, displayName: String) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
    }

    func updatePhotoURL(for user: User, photoURL: URL) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = photoURL
        try await changeRequest.commitChanges()
    }
}
