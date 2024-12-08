//
//  DebugPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Observation

@Observable
final class DebugPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Hashable, Sendable {
        var serverEnvironment: ServerEnvironment = .production
        var getServerEnvironmentStatus: DataStatus = .default
        var setServerEnvironmentStatus: DataStatus = .default

        var appCheckToken: String = ""
        var getAppCheckTokenStatus: DataStatus = .default

        var fcmToken: String = ""
        var getFCMTokenStatus: DataStatus = .default

        var idToken: String = ""
        var getIDTokenStatus: DataStatus = .default

        var isLoading: Bool {
            getServerEnvironmentStatus.isLoading
                || setServerEnvironmentStatus.isLoading
                || getAppCheckTokenStatus.isLoading
                || getFCMTokenStatus.isLoading
                || getIDTokenStatus.isLoading
        }
    }

    enum Action: Hashable, Sendable {
        case onAppear
        case onServerEnvironmentChanged
    }

    var state: State = .init()

    private let debugService: DebugService<Environment> = .init()

    func dispatch(_ action: Action) {
        Task {
            await dispatch(action)
        }
    }

    func dispatch(_ action: Action) async {
        switch action {
        case .onAppear:
            await onAppear()

        case .onServerEnvironmentChanged:
            await onServerEnvironmentChanged()
        }
    }
}

extension DebugPresenter {
    fileprivate func onAppear() async {
        state.getServerEnvironmentStatus = .loading
        state.serverEnvironment = await debugService.getServerEnvironment()
        state.getServerEnvironmentStatus = .loaded

        state.getAppCheckTokenStatus = .loading
        do {
            state.appCheckToken = try await debugService.getAppCheckToken()
            state.getAppCheckTokenStatus = .loaded
        } catch {
            state.getAppCheckTokenStatus = .failed(.init(error))
        }

        state.getFCMTokenStatus = .loading
        do {
            state.fcmToken = try await debugService.getFCMToken()
            state.getFCMTokenStatus = .loaded
        } catch {
            state.getFCMTokenStatus = .failed(.init(error))
        }

        state.getIDTokenStatus = .loading
        do {
            state.idToken = try await debugService.getIdToken()
            state.getIDTokenStatus = .loaded
        } catch {
            state.getIDTokenStatus = .failed(.init(error))
        }
    }

    fileprivate func onServerEnvironmentChanged() async {
        state.setServerEnvironmentStatus = .loading
        do {
            try await debugService.setServerEnvironment(state.serverEnvironment)
            state.setServerEnvironmentStatus = .loaded
        } catch {
            state.setServerEnvironmentStatus = .failed(.init(error))
        }
    }
}
