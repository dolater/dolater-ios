//
//  ContentPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

@preconcurrency import FirebaseAuth
import Observation
import SwiftUI

@Observable
final class ContentPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Equatable {
        var authStatus: AuthStatus = .unchecked
        var registerMeStatus: DataStatus = .default
        var isDebugScreenPresented: Bool = false
        var selection: TabBarItem = .home
        var homeNavigationPath: NavigationPath = .init()
        var accountNavigationPath: NavigationPath = .init()
        var isAddTaskDialogPresented: Bool = false

        enum AuthStatus: Hashable, Sendable {
            case unchecked
            case authenticated(User)
            case unauthenticated
        }
    }

    enum Action: Sendable {
        case onOpenURL(URL)
        case onSelectedTabChanged
        case onPlusButtonTapped
    }

    var state: State = .init()

    private let accountService: AccountService<Environment> = .init()
    private let taskService: TaskService<Environment> = .init()

    private var authListener: NSObjectProtocol?

    init() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if let user = user {
                self?.state.authStatus = .authenticated(user)
                Task {
                    await self?.registerMe()
                }
            } else {
                self?.state.authStatus = .unauthenticated
            }
        }
    }

    deinit {
        Task { [weak self] in
            if let listener = await self?.authListener {
                Auth.auth().removeStateDidChangeListener(listener)
            }
        }
    }

    func dispatch(_ action: Action) {
        Task {
            await dispatch(action)
        }
    }

    func dispatch(_ action: Action) async {
        switch action {
        case .onOpenURL(let url):
            await onOpenURL(url)

        case .onSelectedTabChanged:
            await onSelectedTabChanged()

        case .onPlusButtonTapped:
            await onPlusButtonTapped()
        }
    }
}

extension ContentPresenter {
    fileprivate func onOpenURL(_ url: URL) async {
        Logger.standard.debug("Open URL: \(url.absoluteString)")
        let pathComponents = url.pathComponents
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            Logger.standard.error("Invalid URL: \(url.absoluteString)")
            return
        }
        let _ = components.queryItems
        switch pathComponents.first {
        case "users":
            state.selection = .account

        default:
            return
        }
    }

    fileprivate func onSelectedTabChanged() async {
        state.isAddTaskDialogPresented = false
    }

    fileprivate func onPlusButtonTapped() async {
        state.selection = .home
        state.isAddTaskDialogPresented = true
    }
}

private extension ContentPresenter {
    func registerMe() async {
        do {
            state.registerMeStatus = .default
            try await accountService.registerMe()
            state.registerMeStatus = .loaded
        } catch {
            state.registerMeStatus = .failed(.init(error))
        }
    }
}
