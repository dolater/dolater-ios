//
//  User+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseAuth

extension FirebaseAuth.User: @retroactive @unchecked Sendable {
    static let mock1: FirebaseAuth.User = {
        let user = User(coder: .init())
        user?.uid = "0000000000000000000000000001"
        user?.displayName = "Debug1 User"
        user?.email = "debug1@kantacky.com"
        user?.photoURL = URL(
            string:
                "https://storage.googleapis.com/dolater-app.firebasestorage.app/profile_images/0000000000000000000000000001/00000000-0000-0000-0000-000000000000.png"
        )
        return user!
    }()

    static let mock2: FirebaseAuth.User = {
        let user = User(coder: .init())
        user?.uid = "0000000000000000000000000002"
        user?.displayName = "Debug2 User"
        user?.email = "debug2@kantacky.com"
        user?.photoURL = URL(
            string:
                "https://storage.googleapis.com/dolater-app.firebasestorage.app/profile_images/0000000000000000000000000002/00000000-0000-0000-0000-000000000000.png"
        )
        return user!
    }()
}
