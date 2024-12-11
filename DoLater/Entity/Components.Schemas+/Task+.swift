//
//  Task+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

import Foundation

extension Components.Schemas.Task {
    static let mock1 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://kantacky.com",
        createdAt: .now,
        owner: .mock1,
        pool: .mock1
    )

    static let mock2 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://kantacky.com",
        createdAt: .now,
        completedAt: .now,
        owner: .mock1,
        pool: .mock1
    )

    static let mock3 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://kantacky.com",
        createdAt: .now,
        completedAt: .now,
        archivedAt: .now,
        owner: .mock1,
        pool: .mock1
    )
}
