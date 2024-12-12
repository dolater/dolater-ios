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
        var isDebugScreenPresented: Bool = false
        var selection: TabBarItem = .home
        var homeNavigationPath: NavigationPath = .init()
        var accountNavigationPath: NavigationPath = .init()
        var isAddTaskDialogPresented: Bool = false
        var addingURLString: String = ""

        enum AuthStatus: Hashable, Sendable {
            case unchecked
            case authenticated(User)
            case unauthenticated
        }
    }

    enum Action: Sendable {
        case onAppear
        case onOpenURL(URL)
        case onSelectedTabChanged
        case onPlusButtonTapped
        case onAddTaskButtonTapped
    }

    var state: State = .init()

    private var authListener: NSObjectProtocol?

    init() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if let user = user {
                self?.state.authStatus = .authenticated(user)
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
        case .onAppear:
            await onAppear()

        case .onOpenURL(let url):
            await onOpenURL(url)

        case .onSelectedTabChanged:
            await onSelectedTabChanged()

        case .onPlusButtonTapped:
            await onPlusButtonTapped()

        case .onAddTaskButtonTapped:
            await onAddTaskButtonTapped()
        }
    }
}

extension ContentPresenter {
    fileprivate func onAppear() async {
        guard let user = Auth.auth().currentUser else {
            state.authStatus = .unauthenticated
            return
        }
        state.authStatus = .authenticated(user)
    }

    fileprivate func onOpenURL(_ url: URL) async {
        Logger.standard.debug("Open URL: \(url.absoluteString)")
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            Logger.standard.error("Invalid URL: \(url.absoluteString)")
            return
        }
        let pathComponents = components.path.split(separator: "/")
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

    fileprivate func onAddTaskButtonTapped() async {
        guard let url = URL(string: state.addingURLString) else {
            return
        }
        state.isAddTaskDialogPresented = false
    }
}
