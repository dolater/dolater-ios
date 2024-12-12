//
//  AccountPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Observation
import SwiftUI

@Observable
final class AccountPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Equatable {
        var path: NavigationPath
        var signOutStatus: DataStatus = .default

        enum Path: Hashable {
        }
    }

    enum Action {
        case onSignOutButtonTapped
    }

    var state: State

    private let accountService: AccountService<Environment> = .init()

    init(path: NavigationPath) {
        state = .init(path: path)
    }

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
