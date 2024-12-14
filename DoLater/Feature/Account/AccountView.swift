//
//  AccountView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct AccountView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: AccountPresenter<Environment>
    @Binding private var path: NavigationPath

    init(path: Binding<NavigationPath>) {
        presenter = .init(path: path.wrappedValue)
        _path = path
    }

    var body: some View {
        NavigationStack(path: $presenter.state.path) {
            Group {
                if presenter.state.getUserStatus.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            DLButton(.icon("bell"), style: .secondary) {
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)

                            VStack(spacing: 30) {
                                VStack(spacing: 18) {
                                    if let user = presenter.state.user {
                                        HStack(spacing: 18) {
                                            UserIcon(imageURLString: user.photoURL)
                                                .frame(width: 60, height: 60)

                                            HStack(spacing: 4) {
                                                Text(user.displayName)
                                                    .font(.DL.title1)

                                                Button("", systemImage: "link") {
                                                }
                                                .font(.DL.button)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }

                                    HStack(spacing: 18) {
                                        countView(label: "フレンド", count: presenter.state.friendsCount?.description)
                                        countView(label: "完了したタスク", count: presenter.state.tasksCountString)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }

                            Button("サインアウト") {
                                presenter.dispatch(.onSignOutButtonTapped)
                            }
                            .font(.DL.body2)
                            Button("アカウントを削除") {
                            }
                            .font(.DL.body2)
                            .foregroundStyle(Color.Semantic.Text.alert)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .foregroundStyle(Color.Semantic.Text.primary)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.Semantic.Background.primary)
            .navigationDestination(for: AccountPresenter<Environment>.State.Path.self) { destination in
                switch destination {
                case .notifications:
                    EmptyView()

                case .task(let task):
                    EmptyView()
                }
            }
        }
        .sync($path, $presenter.state.path)
        .task {
            await presenter.dispatch(.onAppear)
        }
    }

    private func countView(label: String, count: String?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.DL.note1)
            Text(count ?? "-")
                .font(.DL.title1)
        }
    }
}

#Preview {
    @Previewable @State var path: NavigationPath = .init()

    AccountView<MockEnvironment>(path: $path)
}
