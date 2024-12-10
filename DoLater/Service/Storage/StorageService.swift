//
//  StorageService.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseStorage
import SwiftUI

final actor StorageService<Environment: EnvironmentProtocol> {
    init() {}

    func uploadProfileImage(_ image: UIImage) async throws -> URL {
        let croppingRect = CGRect(
            x: image.size.width / 4,
            y: image.size.height / 4,
            width: min(image.size.width, image.size.height),
            height: min(image.size.width, image.size.height)
        )
        guard
            let resizedImage = image.cropping(
                to: image.imageOrientation.isLandscape ? croppingRect.switched : croppingRect
            )?.resizing(to: CGSize(width: 512, height: 512))
        else {
            throw StorageServiceError.failedToResizeImage
        }
        guard let data = resizedImage.pngData() else {
            throw StorageServiceError.failedToConvertImageToData
        }
        let user = try await Environment.shared.authRepository.getCurrentUser()
        let path = "profile_images/\(user.uid)/\(UUID().uuidString.lowercased()).png"
        let metadata = try await Environment.shared.storageRepository.upload(data, to: path)
        let urlString = "https://storage.googleapis.com/\(metadata.bucket)/\(path)"
        guard let url = URL(string: urlString) else {
            throw StorageServiceError.failedToGetURL
        }
        return url
    }
}
