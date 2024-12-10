//
//  AuthRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/5/24.
//

import FirebaseAuth

protocol AuthRepositoryProtocol: Actor {
    func getCurrentUser() async throws -> User

    func updateDisplayName(for user: User, displayName: String) async throws

    func updatePhotoURL(for user: User, photoURL: URL) async throws

    func signOut() async throws
}

final actor AuthRepositoryImpl: AuthRepositoryProtocol {
    func getCurrentUser() async throws -> User {
        guard let user = Auth.auth().currentUser else {
            throw AuthRepositoryError.unauthenticated
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

    func signOut() async throws {
        try Auth.auth().signOut()
    }
}
