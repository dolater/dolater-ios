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
        var isAddingURLFocused: Bool = false
        var addingURLString: String = ""
        var addingURLAlert: String?
        var addTaskStatus: DataStatus = .default

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
        case onAddingTaskDismissed
        case onAddingTaskConfirmed
    }

    var state: State = .init()

    private let accountService: AccountService<Environment> = .init()
    private let taskService: TaskService<Environment> = .init()

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

        case .onAddingTaskDismissed:
            await onAddingTaskDismissed()

        case .onAddingTaskConfirmed:
            await onAddingTaskConfirmed()
        }
    }
}

extension ContentPresenter {
    fileprivate func onAppear() async {
        guard let user = Auth.auth().currentUser else {
            state.authStatus = .unauthenticated
            return
        }
        do {
            state.registerMeStatus = .default
            try await accountService.registerMe()
            state.registerMeStatus = .loaded
        } catch {
            state.registerMeStatus = .failed(.init(error))
        }
        state.authStatus = .authenticated(user)
    }

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
        state.isAddingURLFocused = true
    }

    fileprivate func onAddingTaskDismissed() async {
        state.isAddTaskDialogPresented = false
        state.isAddingURLFocused = false
        state.addingURLString = ""
        state.addingURLAlert = nil
    }

    fileprivate func onAddingTaskConfirmed() async {
        guard
            let url = URL(string: state.addingURLString),
            UIApplication.shared.canOpenURL(url),
            !(url.host()?.isEmpty ?? true)
        else {
            state.addingURLAlert = "有効なURLを入力してください"
            return
        }
        do {
            state.addTaskStatus = .loading
            let task = try await taskService.addTask(task: .init(url: url.absoluteString))
            state.addTaskStatus = .loaded
        } catch {
            state.addTaskStatus = .failed(.init(error))
        }
        state.isAddTaskDialogPresented = false
        state.isAddingURLFocused = false
        state.addingURLString = ""
        state.addingURLAlert = nil
    }
}
