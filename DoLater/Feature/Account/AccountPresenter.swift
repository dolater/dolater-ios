//
//  AccountPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Observation

@Observable
final class AccountPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Hashable, Sendable {
        var signOutStatus: DataStatus = .default
    }

    enum Action: Hashable, Sendable {
        case onSignOutButtonTapped
    }

    var state: State = .init()

    private let accountService: AccountService<Environment> = .init()

    func dispatch(_ action: Action) {
        Task {
            await dispatch(action)
        }
    }

    func dispatch(_ action: Action) async {
        switch action {
        case .onSignOutButtonTapped:
            await onSignOutButtonTapped()
        }
    }
}

private extension AccountPresenter {
    func onSignOutButtonTapped() async {
        state.signOutStatus = .loading
        do {
            try await accountService.signOut()
            state.signOutStatus = .loaded
        } catch {
            state.signOutStatus = .failed(.init(error))
        }
    }
}
