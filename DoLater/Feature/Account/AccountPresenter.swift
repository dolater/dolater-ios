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
        var user: Components.Schemas.User?
        var getUserStatus: DataStatus = .default
        var friendsCount: Int?
        var getFriendsCountStatus: DataStatus = .default
        var tasksCount: Int?
        var getTaskCountStatus: DataStatus = .default

        var tasksCountString: String? {
            guard let tasksCount else {
                return nil
            }
            if tasksCount < 1000 {
                return tasksCount.description
            }
            if tasksCount < 1000000 {
                return String(format: "%.1fK", Double(tasksCount) / 1000)
            }
            return String(format: "%.1fM", Double(tasksCount) / 1000000)
        }

        enum Path: Hashable {
            case notifications
            case task(DLTask)
        }
    }

    enum Action {
        case onAppear
        case onSignOutButtonTapped
    }

    var state: State

    private let accountService: AccountService<Environment> = .init()
    private let taskService: TaskService<Environment> = .init()

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
        case .onAppear:
            await onAppear()

        case .onSignOutButtonTapped:
            await onSignOutButtonTapped()
        }
    }
}

private extension AccountPresenter {
    func onAppear() async {
        do {
            state.getUserStatus = .loading
            state.user = try await accountService.getMe()
            state.getUserStatus = .loaded
        } catch {
            state.getUserStatus = .failed(.init(error))
        }

        do {
            state.getFriendsCountStatus = .loading
            let friends = try await accountService.getFriends()
            state.friendsCount = friends.count
            state.getFriendsCountStatus = .loaded
        } catch {
            state.getFriendsCountStatus = .failed(.init(error))
        }

        do {
            state.getTaskCountStatus = .loading
            let tasks = try await taskService.getActiveTasks()
            state.tasksCount = tasks.count
            state.getTaskCountStatus = .loaded
        } catch {
            state.getTaskCountStatus = .failed(.init(error))
        }
    }

    func onSignOutButtonTapped() async {
        do {
            state.signOutStatus = .loading
            try await accountService.signOut()
            state.signOutStatus = .loaded
        } catch {
            state.signOutStatus = .failed(.init(error))
        }
    }
}
