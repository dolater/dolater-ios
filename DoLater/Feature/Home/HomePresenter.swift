//
//  HomePresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Observation
import SwiftUI

@Observable
final class HomePresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Equatable {
        var path: NavigationPath

        enum Path: Hashable {
        }
    }

    enum Action {
    }

    var state: State

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
        }
    }
}

private extension HomePresenter {
}
