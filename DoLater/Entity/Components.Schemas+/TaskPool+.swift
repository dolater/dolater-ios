//
//  TaskPool+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

import Foundation

extension Components.Schemas.TaskPool {
    static let mockActive = Components.Schemas.TaskPool(
        id: UUID().uuidString,
        _type: .active
    )

    static let mockArchived = Components.Schemas.TaskPool(
        id: UUID().uuidString,
        _type: .archived
    )

    static let mockBin = Components.Schemas.TaskPool(
        id: UUID().uuidString,
        _type: .bin
    )

    static let mockPending = Components.Schemas.TaskPool(
        id: UUID().uuidString,
        _type: .pending
    )

    static let mocks: [Components.Schemas.TaskPool] = [
        .mockActive,
        .mockArchived,
        .mockBin,
        .mockPending,
    ]
}
