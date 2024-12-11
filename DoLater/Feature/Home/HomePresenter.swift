//
//  HomePresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Observation

@Observable
final class HomePresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Hashable, Sendable {
    }

    enum Action: Hashable, Sendable {
    }

    var state: State = .init()

    func dispatch(_ action: Action) {
        Task {
            await dispatch(action)
        }
    }

    func dispatch(_ action: Action) async {
        switch action {
        }
    }
}

private extension HomePresenter {
}
