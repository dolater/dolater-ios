//
//  DLTask.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct DLTask: Equatable, Identifiable, Sendable {
    var id: UUID
    var status: Status
    var url: URL
    var title: String
    var image: Image
    var createdAt: Date

    enum Status {
        case opened
        case half
        case closed

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
        image: Image(systemName: "globe"),
        createdAt: .now
    )
    static let mock2 = DLTask(
        id: .init(),
        status: .half,
        url: .init(string: "https://developer.apple.com/documentation/swiftui")!,
        title: "SwiftUI | Apple Developer Documentation",
        image: Image(systemName: "globe"),
        createdAt: .now
    )
    static let mock3 = DLTask(
        id: .init(),
        status: .opened,
        url: .init(string: "https://developer.apple.com/documentation/spritekit")!,
        title: "SpriteKit | Apple Developer Documentation",
        image: Image(systemName: "globe"),
        createdAt: .now
    )
    static let mock4 = DLTask(
        id: .init(),
        status: .opened,
        url: .init(string: "https://developer.apple.com/documentation/scenekit")!,
        title: "SceneKit | Apple Developer Documentation",
        image: Image(systemName: "globe"),
        createdAt: .now
    )
    static let mock5 = DLTask(
        id: .init(),
        status: .opened,
        url: .init(string: "https://developer.apple.com/documentation/realitykit")!,
        title: "RealityKit | Apple Developer Documentation",
        image: Image(systemName: "globe"),
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
