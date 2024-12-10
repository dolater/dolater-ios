//
//  User+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

import FirebaseAuth

extension Components.Schemas.User {
    static let mock1 = Components.Schemas.User(
        id: FirebaseAuth.User.mock.uid,
        displayName: FirebaseAuth.User.mock.displayName ?? "",
        photoURL: FirebaseAuth.User.mock.photoURL?.absoluteString ?? "",
        activeTaskPool: .mock1,
        archivedTaskPool: .mock2,
        pendingTaskPool: .mock3,
        followings: []
    )
}
