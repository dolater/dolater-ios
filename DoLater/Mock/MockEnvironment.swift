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
    let httpRepository: any HTTPRepositoryProtocol
    let localRepository: any LocalRepositoryProtocol
    let messagingRepository: any MessagingRepositoryProtocol
    let remoteConfigRepository: any RemoteConfigRepositoryProtocol
    let storageRepository: any StorageRepositoryProtocol
    let userRepository: any UserRepositoryProtocol
    let taskPoolRepository: any TaskPoolRepositoryProtocol
    let taskRepository: any TaskRepositoryProtocol

    init(
        appCheckRepository: any AppCheckRepositoryProtocol = MockAppCheckRepository(),
        authRepository: any AuthRepositoryProtocol = MockAuthRepository(),
        httpRepository: any HTTPRepositoryProtocol = MockHTTPRepository(),
        localRepository: any LocalRepositoryProtocol = MockLocalRepository(),
        messagingRepository: any MessagingRepositoryProtocol = MessagingRepositoryImpl(),
        remoteConfigRepository: any RemoteConfigRepositoryProtocol = MockRemoteConfigRepository(),
        storageRepository: any StorageRepositoryProtocol = MockStorageRepository(),
        userRepository: any UserRepositoryProtocol = MockUserRepository(),
        taskPoolRepository: any TaskPoolRepositoryProtocol = MockTaskPoolRepository(),
        taskRepository: any TaskRepositoryProtocol = MockTaskRepository()
    ) {
        self.appCheckRepository = appCheckRepository
        self.authRepository = authRepository
        self.httpRepository = httpRepository
        self.localRepository = localRepository
        self.messagingRepository = messagingRepository
        self.remoteConfigRepository = remoteConfigRepository
        self.storageRepository = storageRepository
        self.userRepository = userRepository
        self.taskPoolRepository = taskPoolRepository
        self.taskRepository = taskRepository
    }
}
