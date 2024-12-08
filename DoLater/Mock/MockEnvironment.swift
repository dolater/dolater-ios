//
//  MockEnvironment.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

final actor MockEnvironment: EnvironmentProtocol {
    static let shared: MockEnvironment = .init()

    let accountRepository: any AccountRepositoryProtocol
    let appCheckRepository: any AppCheckRepositoryProtocol
    let localRepository: any LocalRepositoryProtocol
    let pushNotificationRepository: any PushNotificationRepositoryProtocol
    let remoteConfigRepository: any RemoteConfigRepositoryProtocol
    let storageRepository: any StorageRepositoryProtocol

    init(
        accountRepository: any AccountRepositoryProtocol = MockAccountRepository(),
        appCheckRepository: any AppCheckRepositoryProtocol = MockAppCheckRepository(),
        localRepository: any LocalRepositoryProtocol = MockLocalRepository(),
        pushNotificationRepository: any PushNotificationRepositoryProtocol =
            MockPushNotificationRepository(),
        remoteConfigRepository: any RemoteConfigRepositoryProtocol = MockRemoteConfigRepository(),
        storageRepository: any StorageRepositoryProtocol = MockStorageRepository()
    ) {
        self.accountRepository = accountRepository
        self.appCheckRepository = appCheckRepository
        self.localRepository = localRepository
        self.pushNotificationRepository = pushNotificationRepository
        self.remoteConfigRepository = remoteConfigRepository
        self.storageRepository = storageRepository
    }
}
