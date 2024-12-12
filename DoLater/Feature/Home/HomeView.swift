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

    init(path: Binding<NavigationPath>) {
        presenter = .init(path: path.wrappedValue)
        _path = path
    }

    var body: some View {
        NavigationStack(path: $presenter.state.path) {
            TaskListView<Environment>(path: $presenter.state.path)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .background(Color.Semantic.Background.primary)
                .navigationDestination(for: HomePresenter<Environment>.State.Path.self) { _ in
                }
                .navigationDestination(for: TaskListPresenter<Environment>.State.Path.self) { destination in
                    switch destination {
                    case .detail(let task):
                        TaskDetailView(task: task)

                    case .bin:
                        Image.binFull
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                    }
                }
        }
        .sync($path, $presenter.state.path)
    }
}

#Preview {
    @Previewable @State var path: NavigationPath = .init()

    HomeView<MockEnvironment>(path: $path)
}
