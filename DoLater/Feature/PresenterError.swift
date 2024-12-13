//
//  PresenterError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/13/24.
//

import Foundation

enum PresenterError: LocalizedError {
    case task(TaskPresenterError)

    var errorDescription: String? {
        switch self {
        case .task(let error):
            return error.localizedDescription
        }
    }
}
