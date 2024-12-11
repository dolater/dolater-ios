//
//  TaskService.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Foundation
import SwiftUI

final actor TaskService<Environment: EnvironmentProtocol> {
    init() {}

    func getPageIcon(for url: URL) async throws -> Image {
        let urlString = url.absoluteString
        guard let urlComponents = URLComponents(string: urlString) else {
            throw TaskServiceError.failedToGetURLComponents
        }
        let faviconURLString = urlComponents.scheme?.appending("://").appending(urlComponents.host ?? "").appending("/favicon.ico") ?? ""
        guard let faviconURL = URL(string: faviconURLString) else {
            throw TaskServiceError.failedToConvertStringToURL
        }
        let data = try await Environment.shared.httpRepository.get(for: faviconURL)
        guard let uiImage = UIImage(data: data) else {
            throw TaskServiceError.failedToConvertData
        }
        return Image(uiImage: uiImage)
    }

    func getPageTitle(for url: URL) async throws -> String {
        let data = try await Environment.shared.httpRepository.get(for: url)
        guard let content = String(data: data, encoding: .utf8) else {
            throw TaskServiceError.failedToConvertData
        }

        guard
            let range = content.range(
            of: "<title>.*?</title>",
            options: .regularExpression
        )
        else {
            throw TaskServiceError.failedToGetTitle
        }
        let title = content[range].replacingOccurrences(of: "</?title>", with: "", options: .regularExpression)
        return title
    }
}
