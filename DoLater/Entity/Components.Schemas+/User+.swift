//
//  User+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

import FirebaseAuth

extension Components.Schemas.User {
    static let mock1 = Components.Schemas.User(
        id: FirebaseAuth.User.mock1.uid,
        displayName: FirebaseAuth.User.mock1.displayName ?? "",
        photoURL: FirebaseAuth.User.mock1.photoURL?.absoluteString ?? "",
        pools: [.mock1, .mock2, .mock3, .mock4]
    )

    static let mock2 = Components.Schemas.User(
        id: FirebaseAuth.User.mock2.uid,
        displayName: FirebaseAuth.User.mock2.displayName ?? "",
        photoURL: FirebaseAuth.User.mock2.photoURL?.absoluteString ?? "",
        pools: [.mock1, .mock2, .mock3, .mock4]
    )
}
