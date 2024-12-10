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
        title: "",
        url: "https://kantacky.com",
        createdAt: .now
    )

    static let mock2 = Components.Schemas.Task(
        id: UUID().uuidString,
        title: "",
        url: "https://kantacky.com",
        createdAt: .now,
        completedAt: .now
    )

    static let mock3 = Components.Schemas.Task(
        id: UUID().uuidString,
        title: "",
        url: "https://kantacky.com",
        createdAt: .now,
        completedAt: .now,
        archivedAt: .now
    )

    static let mock4 = Components.Schemas.Task(
        id: UUID().uuidString,
        title: "",
        url: "https://kantacky.com",
        createdAt: .now,
        completedAt: .now,
        archivedAt: .now,
        deletedAt: .now
    )
}
