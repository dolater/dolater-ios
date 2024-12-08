//
//  SignInService.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import AuthenticationServices
import FirebaseAuth

final actor AccountService<Environment: EnvironmentProtocol> {
    init() {}

    /// Make Sign in with Apple Request
    /// - Parameter request: Sign in with Apple Request
    /// - Returns: Nonce
    func onSignInWithAppleRequested(request: ASAuthorizationAppleIDRequest) -> String {
        request.requestedScopes = [.fullName, .email]
        let nonce = CryptoUtils.randomNonceString()
        request.nonce = CryptoUtils.sha256(nonce)
        return nonce
    }

    func onSignInWithAppleCompleted(result: Result<ASAuthorization, Error>, currentNonce: String?)
        async throws
    {
        switch result {
        case .success(let success):
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    let error = ServiceError.account(.noPreviousRequest)
                    Logger.standard.error("\(error)")
                    throw error
                }
                Logger.standard.debug("Authorized scopes: \(appleIDCredential.authorizedScopes)")
                guard let appleIDToken = appleIDCredential.identityToken else {
                    let error = ServiceError.account(.noIdentityToken)
                    Logger.standard.error("\(error)")
                    throw error
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    let error = ServiceError.account(.failedToSerializeToken)
                    Logger.standard.error("\(error)")
                    throw error
                }
                let credential = OAuthProvider.credential(
                    providerID: .apple, idToken: idTokenString, rawNonce: nonce)
                let result = try await Auth.auth().signIn(with: credential)
                try await updateProfile(for: result.user, with: appleIDCredential)
            }

        case .failure(let error):
            throw error
        }
    }

    func signInWithEmailAndPassword(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }

    func updateProfile(for user: User, displayName: String?, photoURL: URL?) async throws {
        if let displayName {
            try await Environment.shared.accountRepository.updateDisplayName(
                for: user, displayName: displayName)
        }
        if let photoURL {
            try await Environment.shared.accountRepository.updatePhotoURL(
                for: user, photoURL: photoURL)
        }
    }
}

extension AccountService {
    private func updateProfile(
        for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential,
        force: Bool = false
    ) async throws {
        if !force && !(user.displayName ?? "").isEmpty {
            return
        }
        guard let fullName = appleIDCredential.fullName else {
            return
        }
        let displayName = ProfileUtility.buildFullName(fullName: fullName)
        try await Environment.shared.accountRepository.updateDisplayName(
            for: user, displayName: displayName)
    }
}
