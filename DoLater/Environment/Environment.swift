//
//  Environment.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

protocol EnvironmentProtocol: Actor {
    static var shared: Self { get }

    var accountRepository: AccountRepositoryProtocol { get }
    var appCheckRepository: AppCheckRepositoryProtocol { get }
    var localRepository: LocalRepositoryProtocol { get }
    var pushNotificationRepository: PushNotificationRepositoryProtocol { get }
    var remoteConfigRepository: RemoteConfigRepositoryProtocol { get }
    var storageRepository: StorageRepositoryProtocol { get }
}

final actor EnvironmentImpl: EnvironmentProtocol {
    static let shared: EnvironmentImpl = .init()

    let accountRepository: any AccountRepositoryProtocol
    let appCheckRepository: any AppCheckRepositoryProtocol
    let localRepository: any LocalRepositoryProtocol
    let pushNotificationRepository: any PushNotificationRepositoryProtocol
    let remoteConfigRepository: any RemoteConfigRepositoryProtocol
    let storageRepository: any StorageRepositoryProtocol

    init(
        accountRepository: any AccountRepositoryProtocol = AccountRepositoryImpl(),
        appCheckRepository: any AppCheckRepositoryProtocol = AppCheckRepositoryImpl(),
        localRepository: any LocalRepositoryProtocol = LocalRepositoryImpl(),
        pushNotificationRepository: any PushNotificationRepositoryProtocol =
            PushNotificationRepositoryImpl(),
        remoteConfigRepository: any RemoteConfigRepositoryProtocol = RemoteConfigRepositoryImpl(),
        storageRepository: any StorageRepositoryProtocol = StorageRepositoryImpl()
    ) {
        self.accountRepository = accountRepository
        self.appCheckRepository = appCheckRepository
        self.localRepository = localRepository
        self.pushNotificationRepository = pushNotificationRepository
        self.remoteConfigRepository = remoteConfigRepository
        self.storageRepository = storageRepository
    }
}
