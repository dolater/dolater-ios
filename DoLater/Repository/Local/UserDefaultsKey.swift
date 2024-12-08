//
//  UserDefaultsKey.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

struct UserDefaultsKey: Codable, Hashable, Identifiable, Sendable {
    let name: String
    var id: String { name }

    init(name: String) {
        self.name = name
    }
}

extension UserDefaultsKey {
    static let serverEnvironment = UserDefaultsKey(
        name: "server_environment"
    )
}
