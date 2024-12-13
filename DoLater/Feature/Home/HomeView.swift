//
//  HomeView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct HomeView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: HomePresenter<Environment>
    @Binding private var path: NavigationPath
    @Binding private var isAddTaskDialogPresented: Bool

    init(path: Binding<NavigationPath>, isAddTaskDialogPresented: Binding<Bool>) {
        presenter = .init(path: path.wrappedValue)
        _path = path
        _isAddTaskDialogPresented = isAddTaskDialogPresented
    }
    
    var body: some View {
        NavigationStack(path: $presenter.state.path) {
            TaskListView<Environment>(
                path: $presenter.state.path,
                isAddTaskDialogPresented: $isAddTaskDialogPresented
            )
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .background(Color.Semantic.Background.primary)
            .navigationDestination(for: HomePresenter<Environment>.State.Path.self) { _ in
            }
        }
        .sync($path, $presenter.state.path)
    }
}

#Preview {
    @Previewable @State var path: NavigationPath = .init()
    @Previewable @State var isAddTaskDialogPresented: Bool = false

    HomeView<MockEnvironment>(
        path: $path,
        isAddTaskDialogPresented: $isAddTaskDialogPresented
    )
}
