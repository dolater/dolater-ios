//
//  DLTask.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Foundation
import SwiftUI

struct DLTask: Codable, Equatable, Identifiable, Sendable, Transferable {
    let id: UUID
    let url: URL
    let createdAt: Date
    var completedAt: Date? = nil
    var archivedAt: Date? = nil

    var isCompleted: Bool {
        completedAt != nil
    }
    var isArchived: Bool {
        archivedAt != nil
    }

    var trashImage: Image {
        if isCompleted || isArchived {
            return .trashClosed
        }
        return .trashOpened
    }

    var radius: CGFloat {
        let maxInterval: TimeInterval = 60 * 60 * 24 * 7 * 4
        let interval = Date().timeIntervalSince(createdAt)
        let minRadius: CGFloat = 50
        let maxRadius: CGFloat = 100
        let width = maxRadius - minRadius
        let value = min(interval, maxInterval)
        let radius = minRadius + width * value / maxInterval
        return radius
    }

    var size: CGFloat {
        radius * 2
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: DLTask.self, contentType: .data)
    }
}

extension DLTask {
    static let mock1 = DLTask(
        id: .init(),
        url: .init(string: "https://developer.apple.com/design/human-interface-guidelines")!,
        createdAt: .now.addingTimeInterval(-60 * 60 * 24 * 7 * 4)
    )
    static let mock2 = DLTask(
        id: .init(),
        url: .init(string: "https://developer.apple.com/documentation/swiftui")!,
        createdAt: .now.addingTimeInterval(-60 * 60 * 24 * 7 * 1)
    )
    static let mock3 = DLTask(
        id: .init(),
        url: .init(string: "https://developer.apple.com/documentation/spritekit")!,
        createdAt: .now
    )
    static let mock4 = DLTask(
        id: .init(),
        url: .init(string: "https://developer.apple.com/documentation/scenekit")!,
        createdAt: .now,
        completedAt: .now
    )
    static let mock5 = DLTask(
        id: .init(),
        url: .init(string: "https://developer.apple.com/documentation/realitykit")!,
        createdAt: .now,
        completedAt: .now,
        archivedAt: .now
    )

    static let mocks: [DLTask] = [
        .mock1,
        .mock2,
        .mock3,
        .mock4,
        .mock5,
    ]
}
