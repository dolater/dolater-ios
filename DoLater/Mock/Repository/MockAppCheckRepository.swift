//
//  MockAppCheckRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseAuth

final actor MockAppCheckRepository: AppCheckRepositoryProtocol {
    func getAppCheckToken() async throws -> String {
        ""
    }
}
