//
//  StorageServiceError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

enum StorageServiceError: LocalizedError {
    case failedToResizeImage
    case failedToConvertImageToData
    case failedToGetURL

    var errorDescription: String? {
        switch self {
        case .failedToResizeImage:
            "Failed to resize image."

        case .failedToConvertImageToData:
            "Failed to convert image to data."

        case .failedToGetURL:
            "Failed to get URL."
        }
    }
}
