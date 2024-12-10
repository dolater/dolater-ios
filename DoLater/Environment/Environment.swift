//
//  Environment.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

protocol EnvironmentProtocol: Actor {
    static var shared: Self { get }

    var appCheckRepository: AppCheckRepositoryProtocol { get }
    var authRepository: AuthRepositoryProtocol { get }
    var localRepository: LocalRepositoryProtocol { get }
    var messagingRepository: MessagingRepositoryProtocol { get }
    var remoteConfigRepository: RemoteConfigRepositoryProtocol { get }
    var storageRepository: StorageRepositoryProtocol { get }
    var taskPoolRepository: TaskPoolRepositoryProtocol { get }
}

final actor EnvironmentImpl: EnvironmentProtocol {
    static let shared: EnvironmentImpl = .init()

    let appCheckRepository: any AppCheckRepositoryProtocol
    let authRepository: any AuthRepositoryProtocol
    let localRepository: any LocalRepositoryProtocol
    let messagingRepository: any MessagingRepositoryProtocol
    let remoteConfigRepository: any RemoteConfigRepositoryProtocol
    let storageRepository: any StorageRepositoryProtocol
    let taskPoolRepository: any TaskPoolRepositoryProtocol

    init(
        appCheckRepository: any AppCheckRepositoryProtocol = AppCheckRepositoryImpl(),
        authRepository: any AuthRepositoryProtocol = AuthRepositoryImpl(),
        localRepository: any LocalRepositoryProtocol = LocalRepositoryImpl(),
        messagingRepository: any MessagingRepositoryProtocol = MessagingRepositoryImpl(),
        remoteConfigRepository: any RemoteConfigRepositoryProtocol = RemoteConfigRepositoryImpl(),
        storageRepository: any StorageRepositoryProtocol = StorageRepositoryImpl(),
        taskPoolRepository: any TaskPoolRepositoryProtocol = TaskPoolRepositoryImpl()
    ) {
        self.appCheckRepository = appCheckRepository
        self.authRepository = authRepository
        self.localRepository = localRepository
        self.messagingRepository = messagingRepository
        self.remoteConfigRepository = remoteConfigRepository
        self.storageRepository = storageRepository
        self.taskPoolRepository = taskPoolRepository
    }
}
