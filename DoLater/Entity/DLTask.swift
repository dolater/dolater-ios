//
//  DLTask.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct DLTask: Codable, Equatable, Identifiable, Sendable, Transferable {
    var id: UUID
    var status: Status
    var url: URL
    var title: String
    var createdAt: Date

    var faviconURL: URL? {
        let urlString = url.absoluteString
        guard let urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        let faviconURLString = urlComponents.scheme?.appending("://").appending(urlComponents.host ?? "").appending("/favicon.ico") ?? ""
        guard let faviconURL = URL(string: faviconURLString) else {
            return nil
        }
        return faviconURL
    }

    var size: CGFloat {
        120
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: DLTask.self, contentType: .data)
    }

    enum Status: Codable, Equatable, Identifiable, Sendable {
        case opened
        case half
        case closed

        var id: Self { self }

        var image: Image {
            switch self {
            case .opened: .trashOpened
            case .half: .trashHalf
            case .closed: .trashClosed
            }
        }
    }
}

extension DLTask {
    static let mock1 = DLTask(
        id: .init(),
        status: .closed,
        url: .init(string: "https://developer.apple.com/design/human-interface-guidelines")!,
        title: "Apple Developer Documentation Human Interface Guidelines | Apple Developer Documentation",
        createdAt: .now
    )
    static let mock2 = DLTask(
        id: .init(),
        status: .half,
        url: .init(string: "https://developer.apple.com/documentation/swiftui")!,
        title: "SwiftUI | Apple Developer Documentation",
        createdAt: .now
    )
    static let mock3 = DLTask(
        id: .init(),
        status: .opened,
        url: .init(string: "https://developer.apple.com/documentation/spritekit")!,
        title: "SpriteKit | Apple Developer Documentation",
        createdAt: .now
    )
    static let mock4 = DLTask(
        id: .init(),
        status: .opened,
        url: .init(string: "https://developer.apple.com/documentation/scenekit")!,
        title: "SceneKit | Apple Developer Documentation",
        createdAt: .now
    )
    static let mock5 = DLTask(
        id: .init(),
        status: .opened,
        url: .init(string: "https://developer.apple.com/documentation/realitykit")!,
        title: "RealityKit | Apple Developer Documentation",
        createdAt: .now
    )

    static let mocks: [DLTask] = [
        .mock1,
        .mock2,
        .mock3,
        .mock4,
        .mock5,
    ]
}
