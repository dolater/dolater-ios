//
//  RemoteConfigKey.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

struct RemoteConfigKey: Codable, Hashable, Identifiable, Sendable {
    let name: String
    var id: String { name }

    init(name: String) {
        self.name = name
    }
}

extension RemoteConfigKey {
    static let isValidAppVersion = RemoteConfigKey(
        name: "is_valid_app_version"
    )
}
