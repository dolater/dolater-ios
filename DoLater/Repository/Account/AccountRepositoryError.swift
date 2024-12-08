//
//  AccountRepositoryError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/6/24.
//

import Foundation

enum AccountRepositoryError: LocalizedError {
    case unauthenticated

    var errorDescription: String? {
        switch self {
        case .unauthenticated:
            return "Unauthenticated"
        }
    }
}
