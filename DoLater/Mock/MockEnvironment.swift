//
//  MockEnvironment.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

final actor MockEnvironment: EnvironmentProtocol {
    static let shared: MockEnvironment = .init()

    let appCheckRepository: any AppCheckRepositoryProtocol
    let authRepository: any AuthRepositoryProtocol
    let localRepository: any LocalRepositoryProtocol
    let messagingRepository: any MessagingRepositoryProtocol
    let remoteConfigRepository: any RemoteConfigRepositoryProtocol
    let storageRepository: any StorageRepositoryProtocol
    let userRepository: any UserRepositoryProtocol

    init(
        appCheckRepository: any AppCheckRepositoryProtocol = MockAppCheckRepository(),
        authRepository: any AuthRepositoryProtocol = MockAuthRepository(),
        localRepository: any LocalRepositoryProtocol = MockLocalRepository(),
        messagingRepository: any MessagingRepositoryProtocol = MessagingRepositoryImpl(),
        remoteConfigRepository: any RemoteConfigRepositoryProtocol = MockRemoteConfigRepository(),
        storageRepository: any StorageRepositoryProtocol = MockStorageRepository(),
        userRepository: any UserRepositoryProtocol = MockUserRepository()
    ) {
        self.appCheckRepository = appCheckRepository
        self.authRepository = authRepository
        self.localRepository = localRepository
        self.messagingRepository = messagingRepository
        self.remoteConfigRepository = remoteConfigRepository
        self.storageRepository = storageRepository
        self.userRepository = userRepository
    }
}
