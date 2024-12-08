//
//  ContentPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

@preconcurrency import FirebaseAuth
import Observation

@Observable
final class ContentPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Hashable, Sendable {
        var authStatus: AuthStatus = .unchecked
        var isDebugScreenPresented: Bool = false

        enum AuthStatus: Hashable, Sendable {
            case unchecked
            case authenticated(User)
            case unauthenticated
        }
    }

    enum Action: Sendable {
        case onAppear
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
}
