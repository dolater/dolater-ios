//
//  ServiceError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

enum ServiceError: LocalizedError {
    case account(AccountServiceError)

    var errorDescription: String? {
        switch self {
        case .account(let error):
            return "Account Service Error: \(error.localizedDescription)"
        }
    }
}
