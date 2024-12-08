//
//  SignInWithAppleError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

enum AccountServiceError: LocalizedError {
    case noPreviousRequest
    case noIdentityToken
    case failedToSerializeToken

    var errorDescription: String? {
        switch self {
        case .noPreviousRequest:
            "No previous request was made."

        case .noIdentityToken:
            "No identity token was found."

        case .failedToSerializeToken:
            "Failed to serialize the identity token."
        }
    }
}
