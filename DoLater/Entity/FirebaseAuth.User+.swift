//
//  User+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseAuth

extension FirebaseAuth.User: @retroactive @unchecked Sendable {
    static let mock: FirebaseAuth.User? = {
        let user = User(coder: .init())
        user?.uid = "RMEeMr2DfBac2d9oMptq5SrY0JK2"
        user?.displayName = "Debug User"
        user?.email = "debug@kantacky.com"
        user?.photoURL = URL(
            string:
                "https://storage.googleapis.com/dolater-app.firebasestorage.app/profile_images/RMEeMr2DfBac2d9oMptq5SrY0JK2/00000000-0000-0000-0000-000000000000.png"
        )
        return user
    }()
}
