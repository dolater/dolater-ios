//
//  AccountPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Observation
import SwiftUI
import PhotosUI

@Observable
final class AccountPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Equatable {
        var path: NavigationPath
        var user: Components.Schemas.User?
        var getUserStatus: DataStatus = .default
        var friendsCount: Int?
        var getFriendsCountStatus: DataStatus = .default
        var tasksCount: Int?
        var getTaskCountStatus: DataStatus = .default
        var photosPickerItem: PhotosPickerItem?
        var updateProfilePhotoStatus: DataStatus = .default
        var isNameEditing: Bool = false
        var editingNameText: String = ""
        var updateNameStatus: DataStatus = .default
        var tasksFriendHas: [Components.Schemas.User : [Components.Schemas.Task]] = [:]
        var getTasksFriendHasStatus: DataStatus = .default
        var signOutStatus: DataStatus = .default

        var friendsCountString: String? {
            guard let friendsCount else {
                return nil
            }
            if friendsCount < 1000 {
                return friendsCount.description
            }
            if friendsCount < 1000000 {
                return String(format: "%.1fK", Double(friendsCount) / 1000)
            }
            return String(format: "%.1fM", Double(friendsCount) / 1000000)
        }

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
        case onSelectedPhotoChanged
        case onNameTapped
        case onNameSubmitted
        case onTaskFriendHasTapped(DLTask)
        case onSignOutButtonTapped
        case onDeleteAccountButtonTapped
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

        case .onSelectedPhotoChanged:
            await onSelectedPhotoChanged()

        case .onNameTapped:
            await onNameTapped()

        case .onNameSubmitted:
            await onNameSubmitted()

        case .onTaskFriendHasTapped(let task):
            await onTaskFriendHasTapped(task)

        case .onSignOutButtonTapped:
            await onSignOutButtonTapped()

        case .onDeleteAccountButtonTapped:
            await onDeleteAccountButtonTapped()
        }
    }
}

private extension AccountPresenter {
    func onAppear() async {
        Task {
            do {
                state.getUserStatus = .loading
                state.user = try await accountService.getMe()
                state.getUserStatus = .loaded
            } catch {
                state.getUserStatus = .failed(.init(error))
            }
        }

        Task {
            do {
                state.getFriendsCountStatus = .loading
                let friends = try await accountService.getFriends()
                state.friendsCount = friends.count
                state.getFriendsCountStatus = .loaded
            } catch {
                state.getFriendsCountStatus = .failed(.init(error))
            }
        }

        Task {
            do {
                state.getTaskCountStatus = .loading
                let tasks = try await taskService.getActiveTasks()
                state.tasksCount = tasks.count
                state.getTaskCountStatus = .loaded
            } catch {
                state.getTaskCountStatus = .failed(.init(error))
            }
        }

        Task {
            do {
                state.getTasksFriendHasStatus = .loading
                let tasks = try await taskService.getTasksFriendHas()
                Set(tasks.map(\.pool)).forEach { pool in
                    guard let friend = pool.owner else {
                        return
                    }
                    state.tasksFriendHas[friend] = tasks.filter({ task in
                        task.pool.owner == friend
                    })
                }
                state.getTasksFriendHasStatus = .loaded
            } catch {
                state.getTasksFriendHasStatus = .failed(.init(error))
            }
        }
    }

    func onSelectedPhotoChanged() async {
        state.updateProfilePhotoStatus = .loading
        guard let photosPickerItem = state.photosPickerItem else {
            state.updateProfilePhotoStatus = .loaded
            return
        }
        do {
            guard let photo = try await photosPickerItem.loadTransferable(type: Image.self) else {
                state.updateProfilePhotoStatus = .loaded
                return
            }
            state.user = try await accountService.updateProfile(image: photo)
            state.updateProfilePhotoStatus = .loaded
        } catch {
            state.updateProfilePhotoStatus = .failed(.init(error))
        }
    }

    func onNameTapped() async {
        state.editingNameText = state.user?.displayName ?? ""
        state.isNameEditing = true
    }

    func onNameSubmitted() async {
        do {
            state.updateNameStatus = .loading
            state.user = try await accountService.updateProfile(displayName: state.editingNameText)
            state.updateNameStatus = .loaded
            state.isNameEditing = false
        } catch {
            state.updateNameStatus = .failed(.init(error))
        }
    }

    func onTaskFriendHasTapped(_ task: DLTask) async {
        state.path.append(State.Path.task(task))
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

    func onDeleteAccountButtonTapped() async {
    }
}
