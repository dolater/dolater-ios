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
    var httpRepository: HTTPRepositoryProtocol { get }
    var localRepository: LocalRepositoryProtocol { get }
    var messagingRepository: MessagingRepositoryProtocol { get }
    var remoteConfigRepository: RemoteConfigRepositoryProtocol { get }
    var storageRepository: StorageRepositoryProtocol { get }
    var taskPoolRepository: TaskPoolRepositoryProtocol { get }
    var taskRepository: TaskRepositoryProtocol { get }
}

final actor EnvironmentImpl: EnvironmentProtocol {
    static let shared: EnvironmentImpl = .init()

    let appCheckRepository: any AppCheckRepositoryProtocol
    let authRepository: any AuthRepositoryProtocol
    let httpRepository: any HTTPRepositoryProtocol
    let localRepository: any LocalRepositoryProtocol
    let messagingRepository: any MessagingRepositoryProtocol
    let remoteConfigRepository: any RemoteConfigRepositoryProtocol
    let storageRepository: any StorageRepositoryProtocol
    let taskPoolRepository: any TaskPoolRepositoryProtocol
    let taskRepository: any TaskRepositoryProtocol

    init(
        appCheckRepository: any AppCheckRepositoryProtocol = AppCheckRepositoryImpl(),
        authRepository: any AuthRepositoryProtocol = AuthRepositoryImpl(),
        httpRepository: any HTTPRepositoryProtocol = HTTPRepositoryImpl(),
        localRepository: any LocalRepositoryProtocol = LocalRepositoryImpl(),
        messagingRepository: any MessagingRepositoryProtocol = MessagingRepositoryImpl(),
        remoteConfigRepository: any RemoteConfigRepositoryProtocol = RemoteConfigRepositoryImpl(),
        storageRepository: any StorageRepositoryProtocol = StorageRepositoryImpl(),
        taskPoolRepository: any TaskPoolRepositoryProtocol = TaskPoolRepositoryImpl(),
        taskRepository: any TaskRepositoryProtocol = TaskRepositoryImpl()
    ) {
        self.appCheckRepository = appCheckRepository
        self.authRepository = authRepository
        self.httpRepository = httpRepository
        self.localRepository = localRepository
        self.messagingRepository = messagingRepository
        self.remoteConfigRepository = remoteConfigRepository
        self.storageRepository = storageRepository
        self.taskPoolRepository = taskPoolRepository
        self.taskRepository = taskRepository
    }
}
